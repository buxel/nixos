# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:

{
  imports =
    [
      # Include the container-specific autogenerated configuration.
      ./hardware-configuration.nix
      ./rclone.nix
    ];

  # Enable Intel QuickSync for hardware de-/encoding
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
    ];
  };

  # Allow vscode-remote to work on this system
  programs.nix-ld.enable = true;

  modules.tailscale.enable = true;
  modules.ddns.enable = true;
  
  # Services
  modules.whoami.enable = true;
  # modules.cockpit.enable = true;

  services.traefik = {
    extraInternalHostNames = [ "sonarr.zz" "jellyfin.zz" "prowlarr.zz"];
  };

  services.sonarr = {
    enable = true;  
    # name = "sonarr.zz"; # TODO: name is not supported anymore. use traefik config 
  };

  modules.jellyfin = {
    enable = true;  
    # name = "jellyfin.zz";
  };

  # TODO: migrate from old config
  # services.prowlarr = {
  #   enable = true;  
  #   name = "prowlarr.zz";
  # };
}