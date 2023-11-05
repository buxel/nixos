{ config, pkgs, ... }: {

  imports = [ 
    ./hardware-configuration.nix
    # ./storage.nix
  ];

  modules.base.enable = true;
  modules.secrets.enable = true;

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

  
  # Ocis remote data
  modules.rclone.mounts."/mnt/ocis-data" = {
    configPath = config.age.secrets.rclone-conf.path;
    remote = "azure-data:ocis-data";
  };  
  # Ocis
  modules.ocis = { 
    enable = true;
    hostName = "cloud.pingbit.de";
    dataDir = "/mnt/ocis-data";
  };
  

  # Immich remote data
  modules.rclone.mounts."/mnt/photos" = {
    configPath = config.age.secrets.rclone-conf.path;
    remote = "azure-data:photos";
  };
  # Immich 
  modules.immich = {
    enable = true;
    hostName = "photos.pingbit.de";
    photosDir = "/mnt/photos";
  };
}
