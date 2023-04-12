{ config, lib, pkgs, ... }: 

let

  cfg = config.modules.base;
  inherit (lib) mkIf;

in {

  # ---------------------------------------------------------------------------
  # System Enviroment & Packages
  # ---------------------------------------------------------------------------
  config = mkIf cfg.enable {

    environment = {

      # List packages installed in system profile
      systemPackages = with pkgs; [ 
        inetutils mtr sysstat gnumake git # basics
        curl htop tmux rsync vim nix-index jq
        usbutils pciutils zip unzip nmap arp-scan dig lsof 
        nix-zsh-completions zsh-completions 
        nix-bash-completions bash-completion
        home-manager # include home-manager command
        nixos-cli # found in overlays
        cachix # binary cache
      ];

      # Add terminfo files
      enableAllTerminfo = true;

    };

  };

}
