{ inputs, outputs, host, pkgs, lib, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  networking.usePredictableInterfaceNames = false;
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  environment.systemPackages = with pkgs; [
     #vim 
     #neovim
     # tmux
   ];

  virtualisation.docker.enable = true;

  programs.nix-ld.enable = true;

}