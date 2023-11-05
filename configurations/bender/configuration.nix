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

  
  modules.rclone.mounts."/mnt/photos" = {
    configPath = config.age.secrets.rclone-conf.path;
    remote = "azure-data:photos";
  };

  # modules.rclone = {
  #   enable = true;
  #   configPath = config.age.secrets.rclone-conf.path;
  #   remote = "azure-data:photos";
  #   mountPath = "/mnt/photos";
  #   requiredBy = ["immich.service"];
  # };


  # Web services
  modules.ocis.enable = true;
  modules.ocis.hostName = "cloud.pingbit.de";

  modules.immich = {
    enable = true;
    hostName = "photos.pingbit.de";
    photosDir = "/mnt/photos";
  };
}
