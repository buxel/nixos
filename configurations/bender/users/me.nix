{ config, options, lib, pkgs, this, ... }: let 

  home.packages = with pkgs; [ 
    neofetch
    yo
  ];

  programs = {
    git.enable = true;
    tmux.enable = true;
    zsh.enable = true;
  };

}
