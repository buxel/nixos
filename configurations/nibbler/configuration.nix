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
  modules.tailscale.enable = true;
  modules.ddns.enable = true;
  modules.whoami.enable = true;

  # Custom DNS
  modules.blocky.enable = true;

  # Allow vscode-remote to work on this system
  programs.nix-ld.enable = true;

  # modules.cockpit.enable = true;

  # Serve CA cert on http://<nibbler>:1234
  services.traefik = {
    enable = true;
    caPort = 1234;
  };

  services.traefik = {
    extraInternalHostNames = [ "paperless.zz" ];
  };

  modules.paperless = {
    enable = true;  
    name = "paperless.zz";
  };


}
