# Restic backup module
- support multiple repositories
- implement "backup mode" like described here: https://serverfault.com/questions/885117/disable-all-services-except-ssh
    - shut down all services except ssh and restic
    - take BTRFS snapshot
    - start services
    - chroot to snapshot and start restic backup
    - remove snapshot after completion
## Think about
- if multiple destinations are used, when is the snapshot deleted?
- always keep the last snapshout around?
- use btrbk unstead of rclone?
