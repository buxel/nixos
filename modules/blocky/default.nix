# modules.blocky.enable = true;
{ config, lib, pkgs, this, ... }: 

let 

  cfg = config.modules.blocky;
  inherit (lib) mkIf mkOption mkForce types;

in {

  options.modules.blocky = {
    enable = lib.options.mkEnableOption "blocky"; 
    name = mkOption {
      type = types.str;
      default = "blocky";
    };
    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/blocky"; 
    };
  };

  # Use blocky to add custom domains and block unwanted domains
  config = mkIf cfg.enable {

    # Enable reverse proxy for api
    # https://blocky.hub/api/blocking/status
    modules.traefik = {
      enable = true;
      routers.${cfg.name} = "http://127.0.0.1:4000";
    };

    # Ensure directory exists for downloaded lists
    file."${cfg.dataDir}" = {
      type = "dir"; mode = 775; 
    };

    # Blocky supports downloading lists automatically, but sometimes timeouts on slow connections. 
    # Get around that by downloading these lists separately as a systemd service
    systemd.services.blocky-download-lists = {
      description = "Download copy of lists for Blocky";
      after = [ "multi-user.target" ];
      requires = [ "multi-user.target" ];
      wantedBy = [ "sysinit.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
      };
      path = with pkgs; [ curl ];
      script = ''
        curl https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/light.txt > ${cfg.dataDir}/blacklist.txt
        curl https://nsfw.oisd.nl/domainswild > ${cfg.dataDir}/nsfw.txt
        curl https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/whitelist.txt > ${cfg.dataDir}/whitelist.txt
        curl https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/optional-list.txt > ${cfg.dataDir}/whitelist-optional.txt
      '';
    };

    # Run this script every day
    systemd.timers.blocky-download-lists = {
      wantedBy = [ "timers.target" ];
      partOf = [ "blocky-download-lists.service" ];
      timerConfig = {
        OnCalendar = "daily";
        Unit = "blocky-download-lists.service";
      };
    };

    services.redis.servers.blocky = {
      enable = true;
      openFirewall = true;
      port = 6379;
      bind = null;
      databases = 16;
      settings.protected-mode = "no";
    };

    services.blocky = {
      enable = true;
      settings = {

        ports = {
          dns = 53;
          http = "0.0.0.0:4000";
          # http = "127.0.0.1:4000";
        };

        redis = {
          address = "127.0.0.1:6379";
          password = "blocky";
          connectionAttempts = 10;
          connectionCooldown = "5s";
        };

        connectIPVersion = "v4";
        upstream.default = [
          "https://dns.quad9.net/dns-query"
          "https://one.one.one.one/dns-query"
        ];

        bootstrapDns = [{
          upstream = "https://dns.quad9.net/dns-query";
          ips = [ "9.9.9.9" "149.112.112.112" ];
        }];

        customDNS = {
          inherit (this.network) mapping;
          filterUnmappedTypes = true;
          customTTL = "1h";
        };

        blocking = {
          loading = {
            strategy = "fast";
            concurrency = 8;
            refreshPeriod = "4h";
          };
          blackLists = {
            main = [ 
              "${cfg.dataDir}/blacklist.txt"
              "${cfg.dataDir}/nsfw.txt"
              "https://raw.githubusercontent.com/suderman/nixos/main/modules/blocky/blacklist.txt"
            ];
          };
          whiteLists = {
            main = [
              "${cfg.dataDir}/whitelist.txt"
              "${cfg.dataDir}/whitelist-optional.txt"
              "https://raw.githubusercontent.com/suderman/nixos/main/modules/blocky/whitelist.txt"
            ];
          };
          blockTTL = "1m";
          blockType = "zeroIp";
          clientGroupsBlock = {
            default = [ "main" ];
          };
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [
        config.services.blocky.settings.ports.dns
        4000
        # config.services.grafana.settings.server.http_port
      ];
      allowedUDPPorts = [
        config.services.blocky.settings.ports.dns
      ];
    };

  };

}
