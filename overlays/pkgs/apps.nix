{ config, pkgs, ... }: with pkgs; {

  nautilus = {
    id = "org.gnome.Nautilus.desktop";
    package = gnome.nautilus;
  };
  
  firefox = {
    id = "firefox.desktop";
    package = firefox;
  };

  text-editor = {
    id = "org.gnome.TextEditor.desktop";
    package = gnome-text-editor;
  };

  kitty = {
    id = "kitty.desktop";
    package = kitty;
  };

  telegram = {
    id = "org.telegram.desktop.desktop";
    package = telegram-desktop;
  };

  auto-move-windows = { 
    id = "auto-move-windows@gnome-shell-extensions.gcampax.github.com"; 
    package = gnomeExtensions.auto-move-windows; 
  };

  bluetooth-quick-connect = { 
    id = "bluetooth-quick-connect@bjarosze.gmail.com";
    package = gnomeExtensions.bluetooth-quick-connect;
  };

  blur-my-shell = {
    id = "blur-my-shell@aunetx";
    package = gnomeExtensions.blur-my-shell;
  };

  caffeine = {
    id = "caffeine@patapon.info";
    package = gnomeExtensions.caffeine;
  };

  hot-edge = {
    id = "hotedge@jonathan.jdoda.ca";
    package = gnomeExtensions.hot-edge;
  };

  native-window-placement = {
    id = "native-window-placement@gnome-shell-extensions.gcampax.github.com";
    package = gnomeExtensions.native-window-placement;
  };

  runcat = {
    id = "runcat@kolesnikov.se";
    package = gnomeExtensions.runcat;
  };

  user-themes = {
    id = "user-theme@gnome-shell-extensions.gcampax.github.com";
    package = gnomeExtensions.user-themes;
  };

}
