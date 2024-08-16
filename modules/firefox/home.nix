# programs.firefox.enable = true;
{ config, lib, pkgs, ... }: let

  cfg = config.programs.firefox;
  inherit (lib) mkIf;
  inherit (config.services.keyd.lib) mkClass;

  # Window class name
  class = "firefox";

in {

  config = mkIf cfg.enable {

    programs.firefox = {
      profiles.default = {

        settings = {
          "ui.key.menuAccessKeyFocuses" = false; # don't toggle menu with alt key
          "browser.tabs.tabClipWidth" = 999; # hide close button on inactive tabs
          "middlemouse.paste" = false; # I don't use this
          "widget.non-native-theme.scrollbar.style" = 1; # Apple-style scroll bars
          "apz.overscroll.enabled" = true; # elastic scroll bounce
          "browser.uidensity" = 1; # more compact ui
          "browser.compactmode.show" = true;
          "full-screen-api.transition-duration.enter" = "0 0";
          "full-screen-api.transition-duration.leave" = "0 0";
          "full-screen-api.warning.delay" = 0;
          "full-screen-api.warning.timeout" = 0;
          "mousewheel.default.delta_multiplier_y" = 150; # scroll faster
          "browser.tabs.loadDivertedInBackground" = true; # middle click tab in background
        };

        search = {
          default = "Whoogle";
          force = true;
          engines."Whoogle" = let whoogle = "g.sol"; in {
            urls = [{ template = "https://${whoogle}/search?q={searchTerms}"; }];
            iconUpdateURL = "https://${whoogle}/static/img/favicon/apple-icon-144x144.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@wh" ];
            method = "POST";
          };
          engines."Nix Code" = {
            urls = [{ template = "https://github.com/search?type=code&q=lang%3Anix+{searchTerms}"; }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nix" ];
          };
        };

      };
    };

    # keyboard shortcuts
    services.keyd.windows."${mkClass class}" = {
      "alt.f" = "C-f"; # find in page
      "super.o" = "C-l"; # location bar
      "super.f" = "C-f"; # new tab
      "super.t" = "C-t"; # new tab
      "super.w" = "C-w"; # close tab
      "super.[" = "C-pageup"; # prev tab
      "super.]" = "C-pagedown"; # next tab
      "super.n" = "C-n"; # new window
      "super.r" = "C-r"; # reload
    };

    # tag Firefox and Picture-in-Picture windows
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "tag +web2, class:(${class})"
        "tag +pip, title:^(Picture-in-Picture)$"
      ];
    };

  };

}