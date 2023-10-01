# modules.ydotool.enable = true;
{ config, lib, pkgs, ... }: 

let 

  cfg = config.modules.ydotool;
  inherit (config.users) user;
  inherit (lib) mkIf mkOption mkBefore types;

in {

  options.modules.ydotool = {
    enable = lib.options.mkEnableOption "ydotool"; 
  };

  config = mkIf cfg.enable {

    # Install ydotool package
    environment.systemPackages = [ pkgs.ydotool ];

    # Add user to the input group
    users.users."${user}".extraGroups = [ "input" ]; 

    # Give the input group write access to the uinput device
    services.udev.extraRules = lib.mkAfter ''
      # Give ydotoold access to the uinput device
      KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    '';

    # Create service for daemon process
    systemd.services.ydotool = {
      description = "starts ydotoold service";
      requires = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
      wantedBy = [ "sysinit.target" ];
      serviceConfig = {
        Type = "simple";
        User = user;
        Group = "users";
        ExecStart = "${pkgs.ydotool}/bin/ydotoold";
        ExecReload = "${pkgs.util-linux}/bin/kill -HUP $MAINPID";
        Restart = "on-failure";
        KillMode = "process";
        TimeoutSec = 180;
      };
    };

  };

}


