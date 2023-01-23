{ self, super, ... }: 

let
  inherit (self.lib) callPackage enableWayland;

in { 

  # Personal scripts
  yo = self.callPackage ./yo.nix { };

  # These packages support Wayland but sometimes need to be persuaded
  # _1password-gui  = enableWayland { type = "electron"; pkg = super._1password-gui; bin = "1password"; };
  dolphin         = enableWayland { type = "qt"; pkg = super.dolphin; bin = "dolphin"; };
  element-desktop = enableWayland { type = "electron"; pkg = super.element-desktop; bin = "element-desktop"; };
  owncloud-client = enableWayland { type = "qt"; pkg = super.owncloud-client; bin = "owncloud"; };
  plexamp         = enableWayland { type = "electron"; pkg = super.plexamp; bin = "plexamp"; };
  signal-desktop  = enableWayland { type = "electron"; pkg = super.signal-desktop; bin = "signal-desktop"; };
  # slack           = enableWayland { type = "electron"; pkg = super.slack; bin = "slack"; };

}
