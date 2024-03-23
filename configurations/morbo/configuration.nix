# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:

{
  imports =
    [
      # Need to load some defaults for running in an lxc container.
      # This is explained in:
      # https://github.com/nix-community/nixos-generators/issues/79
      "${modulesPath}/virtualisation/lxc-container.nix"
      # Include the default lxd configuration.
      "./hardware-configuration.nix"
    ];

  # This doesn't do _everything_ we need, because `boot.isContainer` is
  # specifically talking about light-weight NixOS containers, not LXC. But it
  # does at least gives us so
  boot.isContainer = true;

  modules.tailscale.enable = true;
  modules.ddns.enable = true;
  
  # Services
  modules.whoami.enable = true;
}