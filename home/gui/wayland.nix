{ config, lib, pkgs, ... }: 

{

  home.sessionVariables = {

    # MOZ_ENABLE_WAYLAND = "1";
    # MOZ_USE_XINPUT2 = "1";
    #
    # WAYLAND_DISPLAY = "wayland-1";
    # # GDK_DPI_SCALE = "1.22";
    #
    # QT_QPA_PLATFORM = "wayland";
    # QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    #
    # # QT_WAYLAND_FORCE_DPI = "physical";
    # # QT_SCALE_FACTOR = "1.25";
    # # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    #
    # # SAL_USE_VCLPLUGIN = "gtk3";
    #
    # NIXOS_OZONE_WL = "1";
  };

}