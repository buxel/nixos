{ final, prev, ... }: let

inherit (prev) lib this fetchurl;

in prev.ocis-bin.overrideAttrs {
    src = fetchurl {
      url = "https://github.com/owncloud/ocis/releases/download/v5.0.1/ocis-5.0.1-linux-arm64";
      hash = "sha256-zH7nJi6A1C+AcHc375vaH1VOxIFplR5Hp5AzmANuiOA=";

    };
}