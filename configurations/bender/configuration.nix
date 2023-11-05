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
  modules.rclone.mounts."/mnt/documents" = {
    configPath = config.age.secrets.rclone-conf.path;
    remote = "azure-data:documents";
    uid = config.ids.uids.ocis;
    gid = config.ids.gids.ocis;
  };  
  # Ocis
  modules.ocis = { 
    enable = true;
    hostName = "cloud.pingbit.de";
    dataDir = "/mnt/documents";
  };
  

  # Immich remote data
  modules.rclone.mounts."/mnt/photos" = {
    configPath = config.age.secrets.rclone-conf.path;
    remote = "azure-data:photos";
    uid = config.ids.uids.immich;
    gid = config.ids.gids.immich;
    mountOpts = [ "log-level=INFO" ];
  };
  # Immich 
  modules.immich = {
    enable = true;
    hostName = "photos.pingbit.de";
    photosDir = "/mnt/photos";
  };
}
