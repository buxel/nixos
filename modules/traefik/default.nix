# services.traefik.enable = true;
{ config, lib, pkgs, this, ... }: let

  cfg = config.services.traefik;
  certs = "${cfg.dataDir}/certs"; # dir for self-signed certificates
  metricsPort = 81;
  acmeEmail = "dns@suderman.org";

  inherit (lib) mkIf mkOption options types subtractLists mapAttrs mkAttrs ls;
  inherit (cfg.lib) mkHostNames mkService mkRouter mkMiddleware mkLabels mkAlias mkHostName;
  inherit (config.age) secrets;

in {

  # Import all *.nix files in this directory
  imports = ls ./.;

  options.services.traefik = {

    # Shortcut for adding reverse proxies
    routers = mkOption { 
      type = with types; anything; 
      default = {};
    };

    # All hostHames Traefik detects
    hostNames = mkOption { 
      type = with types; listOf str; default = [];
    };

    # OpenSSL certificates are created from this
    internalHostNames = mkOption { 
      type = with types; listOf str; default = [];
    };

    # Add additional hostNames to treat as internal
    extraInternalHostNames = mkOption { 
      type = with types; listOf str; default = [];
    };

    # LetsEncrypt certificates are created from this
    externalHostNames = mkOption { 
      type = with types; listOf str; 
      default = [];
    };

    # BlockyDNS mappings are created from this
    privateHostNames = mkOption { 
      type = with types; listOf str; default = [];
    };

    # CloudFlare DNS records are created from this
    publicHostNames = mkOption { 
      type = with types; listOf str; default = [];
    };

    # Collection of hostName to IP addresses from this Traefik configuration
    mapping = mkOption { 
      type = with types; anything; default = {}; 
    };

  };


  config = mkIf cfg.enable {


    # Configure traefik service
    services.traefik = {

      # Combinations:
      # --------------------------------
      # External / Public:  public service on Internet, using CloudFlare & Let's Encrypt
      # External / Private: personal service on LAN/VPN, using CloudFlare & Let's Encrypt
      # Internal / Private: personal service on LAN/VPN, using Blocky & OpenSSL (most common)
      # Internal / Public: invalid combination

      # All hostHames Traefik detects
      hostNames = mkHostNames {};

      # List of private hostNames using local DNS which will have certificates generated by custom CA
      # - OpenSSL certificates are created from this
      internalHostNames = mkHostNames { external = false; } ++ cfg.extraInternalHostNames;

      # List of external hostNames that need certificates generated externally by Let's Encrypt 
      # - LetsEncrypt certificates are created from this
      externalHostNames = subtractLists cfg.extraInternalHostNames ( mkHostNames { external = true; } );

      # List of private hostNames using local DNS which will have certificates generated by custom CA or Let's Encrypt
      # - BlockyDNS mappings are created from this
      privateHostNames = mkHostNames { public = false; };

      # List of public hostNames that require external DNS records in CloudFlare and certificates by Let's Encrypt
      # - CloudFlare DNS records are created from this
      publicHostNames = mkHostNames { public = true; };

      # Collection of hostName to IP addresses from this Traefik configuration
      mapping = mkAttrs cfg.privateHostNames ( _: this.domains.${this.hostName} );
      # --------------------------------

      # v3.0.2
      package = pkgs.stable.traefik;

      # Required so traefik is permitted to watch docker events
      group = "docker"; 

      # Static configuration
      staticConfigOptions = {

        api.insecure = false;
        api.dashboard = true;

        # Allow backend services to have self-signed certs
        serversTransport.insecureSkipVerify = true;

        # Watch docker events and discover services
        providers.docker = {
          endpoint = "unix:///var/run/docker.sock";
          exposedByDefault = false;
        };

        # Listen on port 80 and redirect to port 443
        entryPoints = {

          # Run everything on 443
          websecure.address = ":443";

          # Redirect http to https
          web.address = ":80";
          web.http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };

          # Metrics for prometheus
          metrics.address = ":${toString metricsPort}";

        };

        metrics.addInternals = true;

        metrics.prometheus = {
          entryPoint = "metrics";
          buckets = [ "0.100000" "0.300000" "1.200000" "5.000000" ];
          addServicesLabels = true;
          addEntryPointsLabels = true;
        };

        # Let's Encrypt will check CloudFlare's DNS
        certificatesResolvers.resolver-dns.acme = {
          dnsChallenge.provider = "cloudflare";
          storage = "/var/lib/traefik/cert.json";
          email = acmeEmail;
        };

        global = {
          checkNewVersion = false;
          sendAnonymousUsage = false;
        };

      };

      # Dynamic configuration
      dynamicConfigOptions = {

        http = { 

          # Generate traefik middlewares from configuration routers
          middlewares = ( 
            mapAttrs mkMiddleware cfg.routers 

          # Include a couple extra middlewares often used
          ) // {

            # Basic Authentication is available. User/passwords are encrypted by agenix.
            login.basicAuth.usersFile = secrets.basic-auth.path;

            # Whitelist local network and VPN addresses
            # local.ipWhiteList.sourceRange = [ 
            local.ipAllowList.sourceRange = [ 
              "127.0.0.1/32"   # local host
              "192.168.0.0/16" # local network
              "10.0.0.0/8"     # local network
              "172.16.0.0/12"  # docker network
              "100.64.0.0/10"  # vpn network
            ];
          };

          # Generate traefik services from configuration routers
          services = ( 
            mapAttrs mkService cfg.routers

          # Avoid a config error ensuring at least one service defined
          ) // { "noop" = {}; };

          # Generate traefik routers from configuration routers
          routers = (
            mapAttrs mkRouter cfg.routers
                
          # Make available the traefik dashboard
          ) // {
            traefik = {
              entrypoints = "websecure"; tls = {};
              rule = "Host(`${this.hostName}`) || Host(`traefik.${this.hostName}`)";
              middlewares = "local";
              service = "api@internal";
            }; 
          };

        }; 

        # Add every module certificate into the default store
        tls.certificates = map (name: { 
          certFile = "${certs}/${name}.crt"; 
          keyFile = "${certs}/key"; 
        }) cfg.internalHostNames;

        # Also change the default certificate
        tls.stores.default.defaultCertificate = {
          certFile = "${certs}/${this.hostName}.crt"; 
          keyFile = "${certs}/key"; 
        };

      };

    };

    # Give traefik user permission to read secrets
    users.users.traefik.extraGroups = [ "secrets" ]; 

    # CloudFlare DNS API Token 
    # > https://dash.cloudflare.com/profile/api-tokens
    # ---------------------------------------------------------------------------
    # CF_DNS_API_TOKEN=xxxxxx
    # ---------------------------------------------------------------------------
    systemd.services.traefik.serviceConfig = {
      EnvironmentFile = [ secrets.cloudflare-env.path ];
    };

    # Self-signed certificate directory
    file."${certs}" = {
      type = "dir"; mode = 775; 
      user = "traefik";
      group = "traefik";
    };

    # Generate certificates with openssl
    systemd.services.traefik.preStart = let 
      inherit (builtins) toString;
      inherit (lib) mkBefore unique;
      openssl = "${pkgs.openssl}/bin/openssl"; 
    in mkBefore ''
      [[ -e ${certs}/key ]] || ${openssl} genrsa -out ${certs}/key 4096 
      [[ -e ${certs}/serial ]] || echo "01" > ${certs}/serial 
      for NAME in ${toString (unique cfg.internalHostNames)}; do
        export NAME IP=${this.domains.${this.hostName}}
        ${openssl} req -new -key ${certs}/key -config ${./openssl.cnf} -extensions v3_req -subj "/CN=$NAME" -out ${certs}/csr 
        ${openssl} x509 -req -days 365 -in ${certs}/csr -extfile ${./openssl.cnf} -extensions v3_req -CA ${this.ca} -CAkey ${secrets.ca-key.path} -CAserial ${certs}/serial -out ${certs}/crt
        cat ${certs}/crt ${this.ca} > ${certs}/$NAME.crt
      done;
      rm -f ${certs}/csr ${certs}/crt
    '';

    # Configure prometheus to check traefik's metrics
    services.prometheus = {
      scrapeConfigs = [{ 
        job_name = "traefik"; static_configs = [ 
          { targets = [ "127.0.0.1:${toString metricsPort}" ]; } 
        ]; 
      }];
    };

    # Enable Docker and set to backend (over podman default)
    virtualisation = {
      docker.enable = true;
      docker.storageDriver = "overlay2";
      oci-containers.backend = "docker";
    };

    # Open up the firewall for http and https
    networking.firewall.allowedTCPPorts = [ 80 443 ];

  };

}
