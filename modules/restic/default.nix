# modules.restic.enable = true;
{ config, lib, pkgs, ... }: 

let 

  cfg = config.modules.restic;
  secrets = config.age.secrets;
  inherit (lib) mkIf mkOption mkForce types recursiveUpdate;

in {

  options.modules.restic = {
    enable = lib.options.mkEnableOption "restic"; 
    extraPaths =  mkOption { type = types.listOf (types.str); default = [];};
    exclude =  mkOption { type = types.listOf (types.str); default = [];};
    # execStartPre = mkOption { type = types.str; }; # TODO: hook into this on order to prepare i.e. postgres backups
    # TODO: set services.restic.backups.<name>.repository destination repo from machine config (maybe default to machine name?)
    # TODO: create predefined "destinations" and make them configurable. SO i can have azure, borgbase, etc as destination
    # TODO: find a way to safely do the backup (stop the services before?)
    # TODO: clean up snapshots
    # TODO: do not backup hidden folders in home
    #         - idea: stop services, take btrfs snapshopt, resume services (short downtime), take backup from snapshopt, delete snapshot
  };

  # Use restic to snapshot persistent states and home
  config = mkIf cfg.enable {

    services.restic.backups = let 
      paths = [
        "/nix/state"
      ];
      exclude = [
        "/nix/state/var/lib/docker" # Docker state is kept in mounted volumes under /nix/state/var/lib/<name>
        "/nix/state/var/log" # logs are not required for a restore
        "/nix/state/var/lib/systemd" # systemd is controlled via nix
        ".*" # hidden files/dirs 
      ];
    in {      
      azureBlob =  {
        paths = paths ++ cfg.extraPaths;
        exclude = exclude ++ cfg.exclude;
        environmentFile = secrets.restic-azure-env.path;
        passwordFile = secrets.alphanumeric-secret.path;
        repository = "azure:backup:/";
        initialize = true;
        timerConfig.OnCalendar = "*-*-* *:00:00";
        timerConfig.RandomizedDelaySec = "5m";
      };
    };

  };
}
