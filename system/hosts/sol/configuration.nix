{ inputs, config, lib, pkgs, ... }: {

  imports = [ ../. 
    ../shared/linode.nix
  ];

  # root is tmpfs
  fileSystems."/" = { 
    # device = "none"; fsType = "tmpfs";
    options = [ "size=2G" "mode=755" ]; # limit to 2GB and only writable by root
  };

  # /nix is btrfs
  fileSystems."/nix" = { 
    # device = "/dev/disk/by-uuid/xxx"; fsType = "btrfs";
    options = [ "compress-force=zstd" "noatime" ]; # btrfs mount options
    # options = [ "compress=zstd" "noatime" "space_cache=v2" "discard=async" "subvol=nix" ];
    neededForBoot = true; 
  };

  # desktops.gnome.enable = true;

  services.tailscale.enable = true;
  services.openssh.enable = true;
  programs.mosh.enable = true;

  # services.keyd.enable = true;
  
  # services.traefik.enable = true;
  # # services.whoogle.enable = true;
  # services.whoami.enable = true;

  programs.neovim.enable = true;

  # # Flatpak
  # services.flatpak.enable = true;
  #
  # # SabNZBd
  # services.sabnzbd.enable = true;
  #
  # # https://search.nixos.org/options?show=services.tandoor-recipes.enable&query=services.tandoor-recipes
  # services.tandoor-recipes.enable = true;

  # https://search.nixos.org/options?show=services.gitea.enable&query=services.gitea
  # services.gitea.enable = true;
  # services.gitea.database.type = "mysql";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.fprintd.enable = true;

  # # Steam
  # programs.steam.enable = false;
  #
  # services.mysql.enable = true;
  # services.postgresql.enable = true;

  # programs._1password.enable = true;
  # programs._1password-gui.polkitPolicyOwners = [ "me" ];
  # programs._1password-gui.enable = true;

  # Packages
  # environment.systemPackages = with pkgs; [];

  # Other
  # programs.nix-ld.enable = true;

}