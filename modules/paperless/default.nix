# modules.paperless.enable = true;
{ config, lib, pkgs, this, inputs, ... }: 

let

  cfg = config.modules.paperless;
  inherit (lib) mkIf mkOption types;
  inherit (builtins) toString;
  inherit (this.lib) extraGroups;
  inherit (config.age) secrets;
  inherit (config.services.traefik.lib) mkHostName mkLabels;

in {

  options.modules.paperless = {
    enable = lib.options.mkEnableOption "paperless"; 
    name = mkOption {
      type = types.str;
      default = "paperless";
    }; 
    hostName = mkOption {
      type = types.str;
      default = (mkHostName cfg.name);
    };   
    port = mkOption {
      type = types.port;
      default = 28981;  
    };
  };

  config = mkIf cfg.enable {

    services.paperless = {
      enable = true;
      package = pkgs.paperless-ngx;
      extraConfig = {
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_FILENAME_FORMAT="{created_year}/{correspondent}/{title}";
        PAPERLESS_URL="https://$${cfg.hostName}";
      };
      passwordFile = secrets.alphanumeric-secret.path;
      # address = traefik.hostName cfg.name; # this evaluates to "paperless.bender", which resolves to a TS IP. Traefik cannot reverse proxy to that for some reason
      port = cfg.port;
    };

    services.traefik = { 
      enable = true;
      routers.${cfg.name} = "http://127.0.0.1:${toString cfg.port}";
    };

    # Add admins to the paperless group
    users.users = extraGroups this.admins [ "paperless" ];

  };

}
