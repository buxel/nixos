# Thinkpad T480s Laptop
{
  ids = [ "0001:0001" ];
  settings = {
    main = {

      ## Modifers before:  
      # [Tab]
      # [Capslock]
      # [fn] [Control] [Meta] [Alt] [Space] [Alt] [PrtSc] [Control]

      ## Modifer after:  
      # [Nav/Tab]
      # [Control]
      # [fn] [Control] [Alt] [Super] [Space] [Super] [PrtSc] [Control]
      tab = "overload(nav, tab)";
      capslock = "layer(control)";
      leftcontrol = "layer(control)";
      leftmeta = "layer(alt)";
      leftalt = "layer(super)";
      rightalt = "layer(super)";

    };

  } // import ./all.nix;

}
