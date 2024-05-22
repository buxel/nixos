{ inputs, outputs, lib, config, pkgs, ... }:
let
  inherit (config.age) secrets;
in
{
  environment.systemPackages = with pkgs; [ rclone ];
  
  # RClone service
  systemd.services.rclone-mount = {
    # Ensure the service starts after the network is up
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];

    # Service configuration
    serviceConfig = {
      Type = "simple";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p /home/me/spica"; # Creates folder if didn't exist
      #ExecStart = "${pkgs.rclone}/bin/rclone mount --config ${secrets.rclone-conf.path} spica: /mnt/spica"; # Mounts
      ExecStart = "${pkgs.rclone}/bin/rclone mount --config /home/me/.config/rclone/rclone.conf spica: /home/me/spica"; # Mounts
      ExecStop = "/run/current-system/sw/bin/fusermount -u /home/me/spica"; # Dismounts
      Restart = "on-failure";
      RestartSec = "10s";
      # PermissionsStartOnly = true; # Use root to create the mountpoint, run with user:group specified below
      User = "me";
      Group = "users";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ]; # Required environments
    };
  };

  systemd.mounts = [{
    after = [ "network-online.target" ];
    type = "rclone";
    what = "spica:";
    where = "/mnt/spica2";
    # rw,_netdev,allow_other,args2env,vfs-cache-mode=writes
    options = "rw,_netdev,allow_other,args2env,vfs-cache-mode=writes,config=${secrets.rclone-conf.path},cache-dir=/var/rclone,verbose=2";
  }];
}

