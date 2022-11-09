{ outputs, lib, config, ... }:

let
  hosts = outputs.nixosConfigurations;
  hostname = config.networking.hostName;
  # prefix = "/persist";
  prefix = "";
  # pubKey = host: ../../${host}/ssh_host_ed25519_key.pub;

in {

  services.openssh = {
    enable = true;
    # Harden
    passwordAuthentication = false;
    permitRootLogin = "no";
    # Automatically remove stale sockets
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
    # Allow forwarding ports to everywhere
    gatewayPorts = "clientspecified";

    hostKeys = [{
      path = "${prefix}/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }];
  };

  programs.mosh.enable = true;

  # programs.ssh = {
  #   # Each hosts public key
  #   knownHosts = builtins.mapAttrs (name: _: {
  #     publicKeyFile = pubKey name;
  #     extraHostNames = lib.optional (name == hostname) "localhost";
  #   }) hosts;
  # };

  # Passwordless sudo when SSH'ing with keys
  security.pam.enableSSHAgentAuth = true;
}
