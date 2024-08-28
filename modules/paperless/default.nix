# modules.paperless.enable = true;
{ config, lib, pkgs, this, inputs, ... }: 

let

  cfg = config.modules.paperless;
  inherit (lib) mkIf mkOption types;
  inherit (builtins) toString;
  inherit (this.lib) extraGroups;
  inherit (config.age) secrets;
  inherit (config.services.traefik.lib) mkAlias mkLabels;

in {

  options.modules.paperless = {
    enable = lib.options.mkEnableOption "paperless"; 
    name = mkOption {
      type = types.str;
      default = "paperless";
    }; 


    alias = mkOption { 
      type = types.anything; 
      default = null;
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
      settings = {
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_FILENAME_FORMAT="{created_year}/{correspondent}/{title}";
        PAPERLESS_URL="https://${cfg.alias}";
      };
      passwordFile = secrets.alphanumeric-secret.path;
      # address = traefik.hostName cfg.name; # this evaluates to "paperless.bender", which resolves to a TS IP. Traefik cannot reverse proxy to that for some reason
      port = cfg.port;
    };

    services.traefik = { 
      enable = true;
      proxy = mkAlias cfg.name cfg.alias;
    };

    # Add admins to the paperless group
    users.users = extraGroups this.admins [ "paperless" ];

  };

}
