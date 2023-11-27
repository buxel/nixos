{ self, super, ... }: let pkgs = super; lib = super.lib; in { 

  # Force package to run in Wayland
  # example:
  # owncloud-client = enableWayland { type = "qt"; pkg = pkgs.owncloud-client; bin = "owncloud"; };
  enableWayland = { type, pkg, bin }: 
    let args = {
      qt = "--set QT_QPA_PLATFORM wayland";
      electron = ''
        --add-flags "--enable-features=UseOzonePlatform" \
        --add-flags "--ozone-platform=wayland" \
        --add-flags "--force-device-scale-factor=2"
      '';
    }; in pkgs.symlinkJoin {
      name = bin;
      paths = [ pkg ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/${bin} ${args.${type}}\
      '';
    };

  # Leave my mark
  jonny = "wuz here";

}
