# modules.paperless.enable = true;
{ config, lib, pkgs, this, inputs, ... }: 

let

  cfg = config.modules.paperless;
  inherit (lib) mkIf mkOption types;
  inherit (this.lib) extraGroups;
  inherit (config.age) secrets;
  inherit (config.modules) traefik;

in {

  options.modules.paperless = {
    enable = lib.options.mkEnableOption "paperless"; 
    name = mkOption {
      type = types.str;
      default = "paperless";
    };    
    port = mkOption {
      type = types.port;
      default = config.services.paperless.port;  
    };
  };

  config = mkIf cfg.enable {

    services.paperless = {
      enable = true;
      package = pkgs.paperless-ngx;
      extraConfig = {
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_FILENAME_FORMAT="{created_year}/{correspondent}/{title}";
      };
      # passwordFile = secrets.alphanumeric-secret.path; # service "paperless-copy-password.service" keeps failing if enabled
      address = traefik.hostName cfg.name;
    };

    modules.traefik = { 
      enable = true;
      routers.${cfg.name} = "http://127.0.0.1:${toString cfg.port}";
    };

    # Add admins to the paperless group
    users.users = extraGroups this.admins [ "paperless" ];

  };

}
