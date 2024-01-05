{ inputs, config, lib, pkgs, this, ... }: {

  # Import all *.nix files in this directory
  imports = this.lib.ls ./. ++ [
    inputs.hardware.nixosModules.framework-11th-gen-intel
  ];

  # Use freshest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network
  modules.tailscale.enable = true;
  modules.ddns.enable = true;
  networking.extraHosts = ''
    127.0.0.1 example.com
  '';

  # Broken? Prevents boot.
  modules.sunshine.enable = true;

  # Memory management
  modules.earlyoom.enable = true;


  virtualisation.waydroid.enable = true;

  # Keyboard control
  modules.keyd = {
    enable = true;
    quirks = true;
    settings = ./keyd.conf;
  };
  modules.ydotool.enable = true;

  # Support iOS devices
  modules.libimobiledevice.enable = true;


  modules.garmin.enable = true;
  modules.silverbullet.enable = true;

  # # Database services
  # modules.mysql.enable = true;
  # modules.postgresql.enable = true;
  
  # Web services
  modules.whoami.enable = true;
  modules.tandoor-recipes.enable = false;
  modules.home-assistant.enable = true;
  modules.rsshub.enable = false;
  # modules.backblaze.enable = false;
  modules.wallabag.enable = false;

  modules.cockpit.enable = false;

  modules.nextcloud.enable = false;

  modules.ocis = {
    enable = false;
    dataDir = "/tmp/ocis";
  };

  modules.immich = {
    enable = true;
    # photosDir = "/photos/immich";
  };

  modules.gitea.enable = true;

  modules.photoprism = {
    enable = false;
    photosDir = "/photos";
  };

  services.xserver.desktopManager.retroarch = {
    enable = false;
    package = pkgs.retroarchFull;
  };

  modules.dolphin.enable = true;

  # Apps
  modules.flatpak.enable = true;
  modules.neovim.enable = true;
  modules.steam.enable = false;

  programs.mosh.enable = true;
  programs.kdeconnect.enable = true;

  programs.evolution.enable = true;

  # sudo fwupdmgr update
  services.fwupd.enable = true;

  # Power management
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  services.tlp.settings = {
    SATA_LINKPWR_ON_BAT = "max_performance";
    # CPU_BOOST_ON_BAT = 0;
    # CPU_SCALING_GOVERNOR_ON_BATTERY = "powersave";
    # START_CHARGE_THRESH_BAT0 = 90;
    # STOP_CHARGE_THRESH_BAT0 = 97;
    # RUNTIME_PM_ON_BAT = "auto";
  };

  # # Suspend-then-hibernate after two hours
  # services.logind = {
  #   lidSwitch = "suspend-then-hibernate";
  #   lidSwitchExternalPower = "suspend";
  #   extraConfig = ''
  #     HandlePowerKey=suspend-then-hibernate
  #     IdleAction=suspend-then-hibernate
  #     IdleActionSec=2m
  #   '';
  # };
  # systemd.sleep.extraConfig = "HibernateDelaySec=2h";
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "suspend";
    lidSwitchDocked = "ignore";
    # extraConfig = ''
    #   IdleActionSec=30m
    #   IdleAction=hibernate
    #   HandlePowerKey=hibernate
    # '';
  };
  # services.udev.extraRules = lib.mkAfter ''
  #   ACTION=="add", SUBSYSTEM=="usb", DRIVER=="usb", ATTR{power/wakeup}="enabled"
  # '';

  systemd.user.services.foobar = {
    description = "Foobar NixOS";
    after = [ "graphical-session.target" ];
    requires = [ "graphical-session.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    environment = {
      FOO = "bar";
    };
    path = with pkgs; [ coreutils ];
    script = ''
      touch /tmp/foobar.txt
      date >> /tmp/foobar.txt
    '';
  };


  file."/etc/foo" = { type = "dir"; };
  file."/etc/foo/bar" = { text = "Hello world!"; mode = 665; user = 913; };
  file."/etc/foo/symlink" = { type = "link"; source = /etc/foo/bar; };
  file."/etc/foo/resolv" = { type = "file"; mode = 775; user = "me"; group = "users"; source = /etc/resolv.conf; };
  file."/etc/foo/srv" = { type = "dir"; source = /srv; };

}
