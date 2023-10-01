# modules.withings-sync.enable = true;
{ inputs, config, pkgs, lib, ... }:
  
let 

  cfg = config.modules.withings-sync;
  secrets = config.age.secrets;
  inherit (config.users) user;
  inherit (lib) mkIf;

  # https://github.com/jaroslawhartman/withings-sync/releases/tag/v3.6.1
  img = "ghcr.io/jaroslawhartman/withings-sync:master";
  flags = ''--name withings --rm -e GARMIN_USERNAME -e GARMIN_PASSWORD -v "/home/${user}:/root"''; 

in {

  options.modules.withings-sync = {
    enable = lib.options.mkEnableOption "withings-sync"; 
  };

  config = mkIf cfg.enable {

    # Create shell script wrapper for docker run
    environment.systemPackages = let script = ''
      if [[ -v NONINTERACTIVE ]]; then
        docker run ${flags} ${img} "$@"
      else
        docker run -it ${flags} ${img} "$@"
      fi
    ''; in [( pkgs.writeShellScriptBin "withings-sync" script )];

    # Create systemd service and timer
    systemd.services.withings-sync = {
      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = secrets.withings-env.path; 
      };
      environment = {
        NONINTERACTIVE = "1";
      };
      path = with pkgs; [ docker ];
      script = "/run/current-system/sw/bin/withings-sync";
    };

    # Run this script every two hours
    systemd.timers.withings-sync = {
      wantedBy = [ "timers.target" ];
      partOf = [ "withings-sync.service" ];
      timerConfig = {
        # OnCalendar = "*:0/3";
        OnCalendar = "0/1:00";
        Unit = "withings-sync.service";
      };
    };

  }; 

}
