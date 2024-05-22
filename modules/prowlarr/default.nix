# modules.prowlarr.enable = true;
{ config, lib, pkgs, this, ... }:

let

  cfg = config.modules.prowlarr;
  arr = "prowlarr";
  inherit (config.services.prometheus) exporters;
  inherit (lib) mkIf mkBefore mkOption options types;
  inherit (builtins) toString;

in {

  options.modules.prowlarr = {
    enable = options.mkEnableOption "prowlarr"; 
    name = mkOption {
      type = types.str; 
      default = "prowlarr";
    };
    port = mkOption {
      type = types.port;
      default = 9696; 
    };
  };

  config = mkIf cfg.enable {

    services.prowlarr = {
      enable = true;
      package = pkgs.prowlarr;
    };

    modules.traefik = {
      enable = true;
      routers.${cfg.name} = "http://127.0.0.1:${toString cfg.port}";
    };

  };

}
