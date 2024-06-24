# HHKB Pro 2
# 1 = OFF    # Macintosh mode (enable media keys)
# 2 = ON     #
# 3 = ON     # Delete = BS
# 4 = OFF    # Left Meta = Left Meta (don't reassign to Fn)
# 5 = OFF    # Meta = Meta, Alt = Alt (don't swap modifiers)
# 6 = ON     # Wake Up Enable
{
  ids = [ "0853:0100" "04fe:0006" ];
  settings = {
    main = {

      # Use tab as custom modifier
      tab = "overloadt2(nav, tab, 200)";

      # Leave the default modifiers as-is
      leftalt = "layer(alt)";
      leftmeta = "layer(super)";
      rightmeta = "layer(super)";
      rightalt = "layer(alt)";

      # Fn keypad as media keys
      # [+] next song
      # [-] previous song
      # [/] play pause
      # [*] media program
      kpplus = "nextsong";
      kpminus = "previoussong";
      kpasterisk = "media";
      kpslash = "playpause";

      # Both volume keys together trigger media key
      "volumedown+volumeup" = "media";

      # Fix media key labelled "Eject"
      f20 = "eject";

    };

  } // import ./all.nix;

}
