# services.earlyoom.enable = true;
{ config, lib, ... }:

let
  cfg = config.services.earlyoom;

in {

  config = lib.mkIf cfg.enable {

    services.earlyoom = {
      freeSwapThreshold = 10; # % default
      freeMemThreshold = 10; # % default
      extraArgs = [
          "-g" "--avoid '^(X|plasma.*|konsole|kwin)$'"
          "--prefer '^(electron|libreoffice|gimp)$'"
        ];
     };

   };
}
