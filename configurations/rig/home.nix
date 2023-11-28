{ config, lib, pkgs, ... }: {

  imports = [ ../_/home ];

  home.packages = with pkgs; [ 
    neofetch
    yo
    firefox-wayland
  ];

  programs = {
    git.enable = true;
    tmux.enable = true;
    zsh.enable = true;
  };

  # terminal du jour
  modules.kitty.enable = true;

}
