{ config, pkgs, lib, ... }: {

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
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];

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
  # TODO: maybe inject this into the immich systemd unit: https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html#RequiresMountsFor=
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
  # environment.systemPackages = [ pkgs.unstable.blobfuse ];
  # system.fsPackages = [ pkgs.unstable.blobfuse ];

  # systemd.services."mnt-blobfuse" = {
  #     description = "Mount azure blob storage";
  #     wantedBy = [ "multi-user.target" ];
  #     after = [ "network-online.target" ];
  #     requires = [ "network-online.target" ];
  #     serviceConfig = {
  #       ExecStartPre = [
  #         "${pkgs.coreutils}/bin/mkdir -m 0500 -pv /home/me/mount"
  #         "${pkgs.e2fsprogs}/bin/chattr +i /home/me/mount"  # Stop files being accidentally written to unmounted directory
  #       ];
  #       ExecStart = let
  #         options = [
  #           # "defaults"
  #           # "allow_other"
  #           # "_netdev"
  #           "--config-file=/home/me/blob-ocis.yaml"
  #         ];
  #       in
  #         "${pkgs.unstable.blobfuse}/bin/azure-storage-fuse mount /home/me/mount --foreground --config-file=/home/me/blob-ocis.yaml " # TODO: use --container-name=container2 to override config
  #           + lib.concatMapStringsSep " " (opt: "-o ${opt}") options;
  #       ExecStopPost = "-${pkgs.fuse}/bin/fusermount -u /home/me/mount";
  #       KillMode = "process";
  #       Restart = "on-failure";
  #     };
  #   };

  systemd.mounts = [{
    description = "blobfuse mount test";
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    what = "${pkgs.unstable.blobfuse}/bin/azure-storage-fuse"; #"azure-storage-fuse";
    where = "/mnt/azblob";
    type = "fuse3";
    mountConfig = {
      SloppyOptions = true;
    };
    options = "defaults,_netdev,allow_other,--config-file=/home/me/blob-ocis.yaml"; 
  }]; 

  systemd.automounts = [{
    enable = true;
    after = [ "network-online.target" ];
    before = [ "remote-fs.target" ];
    where = "/mnt/azblob";
    wantedBy = [ "multi-user.target" ];
  }];
}
