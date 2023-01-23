rec {

  # If users are changed, add or edit the user's ~/.ssh/id_rsa.pub
  # If systems are changed, add or edit the system's /etc/ssh/ssh_host_ed25519_key.pub
  # 
  # Then open a shell in the ./secrets directory and run:
  # > agenix -r

  # User keys ~/.ssh/id_rsa.pub
  me = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCqkkVHSFBPNT9ajrgq1lFKNhkf1QJMZgobkL8fsKlx3mle7Ug5GvW/HLymAsfP04zA1CPet4awcufEEolwY7tWfDIdCOi+8xgaJh5Te3AM9Twegc3a2CRL21Mv438LCPU03qhzHh4JPBWbatq5QxTti67joC91XiBjY/vl8aRtyUz2n/tFoS3yhfMb2qP+VU75dgWQw+WDtHbG4bT018JcL+G4wexKBM3vs51t7qdHHkcbjJh/XJ+/+WGg4SkpmzREEtL2VVh7Mn/e0jupZcU4wtsoi7652bYh1kFpi0YvlTWpdwLmhUXx1RpIYsuP/TNePoN+GBcKN+9dmJuJLJFseD8xhuYzOVpFLb/GdXWEAUlMtCdHwg1QjEUcBPTaX0CeLY/kmna1MU4SBGQ6msTDwSNUpEkKEaiv6Fx66XstAzf1g5NEauLw/YGgwDsPGgPfCraS03aJCqieHxBHe5uaD1vBA4zFvV3CBv3uvlKBUsgVbR2A1k4Bvpyw6VlasvpZhh0DoDVWNL30SvTtyVCS1sIey0GwGNYBVDBu5P5LHsCgOESKG32uHkXVEeYTdln35dJyoxP+/zMebJwNTZjGjU19ORthViwibfQMV2J931ZjkLWgVqxnn9t0hltC2845eOJ0BytX5wFxqf4IU5Ix/yuMeUwIlLocz6X6blNbsQ==";
  users = [ me ];

  # System keys /etc/ssh/ssh_host_ed25519_key.pub
  cog = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPm+/Hq+sZM78OZnWY8DT/7O3RGXb0j1+mYElwquD4LJ";
  lux = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfPrHGL3ZkParCHImTtMnxphq3O0UF/L25RDRz28Xeo";
  sol = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEZNXgo4T/cyY/QyI1j3lNVzwg0+U3c7NclpNzY9wH22";
  systems = [ cog lux sol ];

  # All public keys
  all = users ++ systems;

}
