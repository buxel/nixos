# services.tandoor-recipes.enable = true;
{ config, lib, pkgs, ... }:

with config.networking;

let
  cfg = config.services.tandoor-recipes;
  secrets = config.age.secrets;
  port = "8090";
  appPort = "8091";
  inherit (lib) mkIf;
  inherit (lib.strings) toInt;

in {

  config = mkIf cfg.enable {

    # traefik proxy serving nginx proxy
    services.traefik.dynamicConfigOptions.http = {
      routers.tandoor = {
        rule = "Host(`tandoor.${hostName}.${domain}`) || Host(`tandoor.local.${domain}`)";
        tls.certresolver = "resolver-dns";
        middlewares = "local@file";
        service = "tandoor";
      };
      services.tandoor.loadBalancer.servers = [{ url = "http://127.0.0.1:${port}"; }];
    };

    # Create empty directory for mount point 
    system.activationScripts.mkRecipesDir = lib.stringAfter [ "var" ] ''
      mkdir -p /var/recipes
    '';

    # Bind mount of private directory to location accessible for nginx
    fileSystems."/var/recipes" = {
      device = "/var/lib/private/tandoor-recipes/recipes";
      options = ["bind" "ro"];
    };

    # nginx reverse proxy to statically host recipe images, proxy pass for python app
    services.nginx.enable = true;
    services.nginx.virtualHosts."tandoor.${hostName}.${domain}" = {
      listen = [{ port = (toInt port); addr="127.0.0.1"; ssl = false; }];
      extraConfig = ''
        location /media/recipes/ {
          alias /var/recipes/;
        }
        location / {
          proxy_pass http://127.0.0.1:${appPort};
          proxy_set_header Host tandoor.${hostName}.${domain};
          proxy_set_header X-Forwarded-Proto https;
        }
      '';
    };

    # Tandoor port
    services.tandoor-recipes.port = toInt appPort;

    # Environment variable configuration
    services.tandoor-recipes.extraConfig = {
      DB_ENGINE = "django.db.backends.postgresql";
      POSTGRES_HOST = "/var/run/postgresql";
      POSTGRES_PORT = "5432";
      POSTGRES_USER = "tandoor_recipes";
      POSTGRES_DB = "tandoor_recipes";
      GUNICORN_MEDIA = "0";
      DEFAULT_FROM_EMAIL = "tandoor@${domain}";
      ENABLE_SIGNUP = "0";
      ENABLE_PDF_EXPORT = "1";
    };

    # Include SMTP environment variables
    systemd.services.tandoor-recipes.serviceConfig = {
      EnvironmentFile = secrets.smtp-env.path;
    };

    # Postgres database configuration
    services.postgresql = {
      enable = true;
      ensureUsers = [{
        name = "tandoor_recipes";
        ensurePermissions = { "DATABASE tandoor_recipes" = "ALL PRIVILEGES"; };
      }];
      ensureDatabases = [ "tandoor_recipes" ];
    };

    # Ensure the database is brought up first
    systemd.services.tandoor-recipes.after = [ "postgresql.service" ];
    systemd.services.tandoor-recipes.requires = [ "postgresql.service" ];

  };

}
