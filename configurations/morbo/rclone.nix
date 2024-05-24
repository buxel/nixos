{ inputs, outputs, lib, config, pkgs, ... }:
let
  inherit (config.age) secrets;
  target = "/mnt/rclone/spica/";
  #target = "/mnt/spica/";
in
{
  environment.systemPackages = with pkgs; [ rclone ];
  
  users = {
    users = {

      # Create user
      rclone = {
        isSystemUser = true;
        group = "media";
        description = "rclone daemon user";
        home = "/mnt/rclone";
        homeMode = "770";
        createHome = true;
        extraGroups = [ "secrets" ]; 
      };
    };
  };

  # RClone service
  systemd.services.rclone-mount = {
    # Ensure the service starts after the network is up
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];

    # Service configuration
    serviceConfig = {
      Type = "simple";
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p ${target}"; # Creates folder if didn't exist
      ExecStart =  ''
        ${pkgs.rclone}/bin/rclone mount spica: ${target} \
          --config ${secrets.rclone-conf.path} \
          --no-modtime \
          --allow-other \
          --dir-perms 0775 \
          --file-perms 0775 
        '';
      ExecStop = "/run/current-system/sw/bin/fusermount -u ${target}"; # Dismounts
      User = "rclone";
      Group = "media";
      Restart = "always";
      RestartSec = "10s";
      Environment = [ "PATH=/run/wrappers/bin/:$PATH" ]; # Required environments
    };
  };

  # systemd.mounts = [{
  #   after = [ "network-online.target" ];
  #   type = "rclone";
  #   what = "spica:";
  #   where = "/mnt/spica2";
  #   # rw,_netdev,allow_other,args2env,vfs-cache-mode=writes
  #   options = "rw,_netdev,allow_other,args2env,vfs-cache-mode=writes,config=${secrets.rclone-conf.path},cache-dir=/var/rclone,verbose=2";
  # }];
}

