{ config, pkgs, lib, this, ... }: {

  imports = [ 
    ./hardware-configuration.nix
    ./storage.nix
  ];
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Traefik logging
  services.traefik.staticConfigOptions.log.level = "DEBUG";
  
  # Network
  services.tailscale.enable = true;
  # modules.ddns.enable = true;
  services.whoami.enable = true;
  # networking.extraHosts = "";
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
  # networking.nameservers = [ "100.101.148.41" ]; # TODO: Testing, remove later!

  # Custom DNS
  services.blocky.enable = true;

  # Allow vscode-remote to work on this system
  programs.nix-ld.enable = true;

  # modules.cockpit.enable = true;

  # Serve CA cert on http://<bender>:1234
  services.traefik = {
    enable = true;
    caPort = 1234;
  };

  # Ocis
  services.ocis = { 
    enable = true;
    name = "cloud.zz";
  };


  # Immich 
  services.immich = {
    enable = true;
    alias = "photos.zz";
    dataDir = "/mnt/photos";
  };
  # Remove generation of the /geocoding dir because it breaks mounting at /mnt/photos
  # TODO: commented out in the module. my attempts below failed to remove the folder from the config
  # file = builtins.removeAttrs (import ../../modules/immich/default.nix) [ "/mnt/photos/geocoding" ];
  # file."/mnt/photos/geocoding" = lib.mkForce null;


  services.silverbullet = { 
    enable = true;
    #name = "wiki.zz"; 
  };

  services.traefik = {
    proxy."wiki.zz" = "http://silverbullet.bender";
    extraInternalHostNames = [ "wiki.zz" "photos.zz" "cloud.zz"];
  };


  # modules.netdata.enable = true;

}


# Ideas / todos:
# use https://github.com/berberman/nvfetcher to update docker images