# { config, persistence, lib, ... }: {
{ config, lib, ... }: {
  # # Wireless secrets stored through sops
  # sops.secrets.wireless = {
  #   sopsFile = ../secrets.yaml;
  #   neededForUsers = true;
  # };

  networking.wireless = {
    enable = true;
    fallbackToWPA2 = false;
    # Declarative
    # environmentFile = config.sops.secrets.wireless.path;
    # networks = {
    #   "Marcos_2.4Ghz" = {
    #     pskRaw = "@MARCOS_24@";
    #   };
    #   "Marcos_5Ghz" = {
    #     pskRaw = "@MARCOS_50@";
    #   };
    #   "Misterio" = {
    #     pskRaw = "@MISTERIO@";
    #   };
    # };

    # Imperative
    allowAuxiliaryImperativeNetworks = true;
    userControlled = {
      enable = true;
      group = "network";
    };
  };

  # Ensure group exists
  users.groups.network = { };

  # # Persist imperative config
  # environment.persistence = lib.mkIf persistence {
  #   "/persist".files = [
  #     "/etc/wpa_supplicant.conf"
  #   ];
  # };
}
