# modules.hyprland.enable = true;
{ config, pkgs, lib, inputs, ... }: 

let 

  cfg = config.modules.hyprland;
  inherit (lib) mkIf;
  inherit (config.lib.file) mkOutOfStoreSymlink;

  dir = "/etc/nixos/modules/home-manager/hyprland";

in {

  # Import hyprland module
  imports = [ 
    inputs.hyprland.homeManagerModules.default 
    inputs.fufexan.homeManagerModules.eww-hyprland
  ];


  options.modules.hyprland = {
    enable = lib.options.mkEnableOption "hyprland"; 
  };





  config = mkIf cfg.enable {

    modules.eww.enable = true;
    modules.anyrun.enable = true;

    programs.eww-hyprland = {
     enable = true;

     # default package
     package = pkgs.eww-wayland;

     # if you want to change colors
     # colors = builtins.readFile ./macchiato.scss;

     # set to true to reload on change
     autoReload = true; 

    };


    home.packages = with pkgs; [ 
      gnome.nautilus
      wofi
      wezterm
      waybar
      hyprpaper
      brightnessctl
      pamixer
      ncpamixer
      eww-wayland
    ];

    xdg.configFile."hypr/local.conf".source = mkOutOfStoreSymlink "${dir}/local.conf";

    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [
        inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      ];
      extraConfig = ''
        exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        source = ~/.config/hypr/local.conf
      '';
    };
  };

}
