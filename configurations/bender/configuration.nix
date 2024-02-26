{ config, pkgs, lib, ... }: {

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
  modules.tailscale.enable = true;
  modules.ddns.enable = true;
  modules.whoami.enable = true;
  networking.extraHosts = "";
  # networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
  # networking.nameservers = [ "100.101.148.41" ]; # TODO: Testing, remove later!

  # Custom DNS
  modules.blocky.enable = true;

  # Allow vscode-remote to work on this system
  programs.nix-ld.enable = true;

  modules.cockpit.enable = true;

  # Serve CA cert on http://<bender>:1234
  modules.traefik = {
    enable = true;
    caPort = 1234;
  };

  # Ocis
  modules.ocis = { 
    enable = true;
    name = "cloud";
  };
 
  # Immich 
  modules.immich = {
    enable = true;
    name = "photos";
    dataDir = "/mnt/photos";
  };

  modules.silverbullet = { enable = true; name = "wiki"; };
  
  modules.netdata.enable = true;

}


# Ideas / todos:
# use https://github.com/berberman/nvfetcher to update docker images