# modules.eww.enable = true;
{ config, pkgs, lib, inputs, ... }: 

let 

  cfg = config.modules.eww;
  inherit (lib) mkIf;
  inherit (config.lib.file) mkOutOfStoreSymlink;

  dir = "/etc/nixos/modules/home-manager/eww";

  dependencies = with pkgs; [
    config.wayland.windowManager.hyprland.package
    cfg.package
    bash
    blueberry
    bluez
    brillo
    coreutils
    dbus
    findutils
    gawk
    gnome.gnome-control-center
    gnused
    imagemagick
    jaq
    jc
    libnotify
    networkmanager
    pavucontrol
    playerctl
    procps
    pulseaudio
    ripgrep
    socat
    udev
    upower
    util-linux
    wget
    wireplumber
    wlogout
  ];

in {

  options.modules.eww = {
    enable = lib.options.mkEnableOption "eww"; 
    package = lib.mkOption {
      type = with lib.types; nullOr package;
      default = pkgs.eww-wayland;
    };
  };

  config = mkIf cfg.enable {

    home.packages = [ cfg.package ];
    xdg.configFile."eww".source = mkOutOfStoreSymlink "${dir}";

    systemd.user.services.eww = {
      Unit = {
        Description = "Eww Daemon";
        PartOf = ["graphical-session.target"];
      };
      Service = {
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
        ExecStart = "${cfg.package}/bin/eww daemon --no-daemonize";
        Restart = "on-failure";
      };
      Install.WantedBy = ["graphical-session.target"];
    };

  };

}
