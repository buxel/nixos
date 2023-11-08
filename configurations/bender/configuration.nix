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

  

    # Ocis
  modules.ocis = { 
    enable = true;
    hostName = "cloud.pingbit.de";
  };
  # Ocis remote user data 
  # NOTE: rclone does not support symlinks, which OCIS uses.
  # modules.rclone.mounts."${config.modules.ocis.dataDir}" = {
  # modules.rclone.mounts."/var/lib/ocis/storage/users" = {
  #   configPath = config.age.secrets.rclone-conf.path;
  #   remote = "azure-data:ocis-storage-user";
  #   uid = config.ids.uids.ocis;
  #   gid = config.ids.gids.ocis;
  # }; 

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


  ## Testing
system.fsPackages = [ pkgs.unstable.blobfuse ];
systemd.packages = [ pkgs.unstable.blobfuse ];

systemd.mounts = [{
  description = "blobfuse mount test";
  after = [ "network-online.target" ];
  requires = [ "network-online.target" ];
  what = "azure-storage-fuse";
  where = "/home/me/mnt";
  type = "fuse";
  options = "defaults,_netdev,--config-file=/home/me/blob-ocis.yaml,allow_other "; 
}]; 

systemd.automounts = [{
  after = [ "network-online.target" ];
  before = [ "remote-fs.target" ];
  where = "/home/me/mnt";
  wantedBy = [ "multi-user.target" ];
}];
}
