{ inputs, outputs, lib, config, pkgs, ... }:

{

  services.paperless = {
    enable = true;
    # package = pkgs.unstable.paperless-ngx;
    extraConfig = {
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_FILENAME_FORMAT="{created_year}/{correspondent}/{title}";
    };
  };

  services.caddy = {
    virtualHosts = {
      "paperless.zz:80" = {
        extraConfig = ''
          reverse_proxy : localhost:${toString config.services.paperless.port}
        '';
      };
    };
  };
}
