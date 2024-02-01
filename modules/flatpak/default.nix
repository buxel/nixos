# modules.flatpak.enable = true;
{ config, lib, inputs, ... }:

let

  cfg = config.modules.flatpak;
  inherit (lib) mkIf;

in {

  # https://github.com/gmodena/nix-flatpak/blob/main/modules/nixos.nix
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  # options shared with home-manager module
  options.modules.flatpak = import ./options.nix { 
    inherit lib;  
    inherit (cfg) packages betaPackages;
  };

  # config (mostly) shared with home-manager module
  config = mkIf cfg.enable {

    services.flatpak = import ./config.nix { 
      inherit lib;  
      inherit (cfg) packages betaPackages; 
    } // { 
      enable = true; 
    };

    # portal required for flatpak
    xdg.portal.enable = true;

  };

}
