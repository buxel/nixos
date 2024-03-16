{ config, pkgs, lib, ... }:
{
  systemd.services.wake-on-dns = {
    path = with pkgs; [
      bash # adds all binaries from the bash package to PATH
      tshark
      wakeonlan
      "/run/wrappers" # if you need something from /run/wrappers/bin, sudo, for example
    ];
    scriptArgs = "192.168.178.4 d0:50:99:85:3c:82";
    environment = {
      # ip = "192.168.178.3";
      # mac= "d0:50:99:85:3c:82";
      # pause=10;
    };
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    description = "Listen for DNS responses for IP and send WOL.";
    script = ''
      ip=$1
      mac=$2

      echo "Monitoring DNS requests for $ip and sending WoL packet to $mac ."        

      last_run=0
      min_delay=10
      tshark_cf="outbound and port 53"
      tshark_df="dns.a==$ip"

      tshark -n -l -f "$tshark_cf" -Y "$tshark_df" | while read -e line ; do
        diff=$(( $EPOCHSECONDS - $last_run ))
        if [ $diff -gt $min_delay ]
            then
              ( wakeonlan "$mac" )
              last_run=$EPOCHSECONDS
            else
              echo "Not executing, last run too recent: " $diff;
        fi 
      done

    '';
    serviceConfig = {
      Type = "simple";
      # RemainAfterExit = true;
      # User = "root";
      # ExecStart = ''/usr/bin/env "${pkgs.tcpdump}/bin/tcpdump -n -l -i eth0 \"host ''${ip} and (arp[6:2] = 1)\" | while read -r ; do ${pkgs.wakeonlan}/bin(wakeonlan) ''${mac}; echo 'Sent WOL for ''${ip} on ''${mac}'; done"'';         
      #ExecStart = ''${pkgs.tcpdump}/bin/tcpdump -n -l -i eth0'';      
      Restart = "on-failure";
    };
  };
}
