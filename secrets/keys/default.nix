# 69af215d6ce2f1d33c2d069d0e85376e
# Do not modify this file!  It was generated by ‘nixos rekey’ 
# and may be overwritten by future invocations. 
# Please add public keys to /etc/nixos/secrets/keys/*.pub 
rec {

  users.me = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDaBClteYpmg2puo+fVjz8GgcTC1EyLVmoJxqOW6mxw92IPM3SZ71Ksu/Lm7SRDEAJdfqMqBhExbAvKJcC+EGwErXJcTC8V8+EWJfmQaZXvt5QynLPi6d1EbzB5n042j1dZOHQQg8wlygwPQLcEzHwF9QGQCN7iz/rpMeuSQ/Oxh0wT4m/7gPbdfQB4Dm9r2LRLQQ5zmTOD4ErNaQC/w8K4ecBirPd8X3lZYC+S9kO7x3w02vdWPXq5usipbXU3lv9JtWEhxvg0fNSGrhpClqULH2gGaUq2PKbt1iH+GTWcZv7cQChkhlNlwjTvhkS6/mXgSqGNmWfC/Ulcv56V4g+edLZuga3KtYPA9c/NrIbdjSRuJL18THwDlbvqnwr155zaEP6p/KyH/r9kY+mhlclXUOo46jO2rsWHzCb7WZz13hSXU4WVi5aqNvWf0lZIfO54k9nU6DeI7H4AuIxkNRS7bIJJoNjpi8rsTL80Ri8xt2e9TAjE/UlSlELbeMNfp48=";
  users.all = [ users.me ];

  systems._130-61-215-94 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMyTB4H3878weqyISJ6W2Z8Nl9l4xoGp6pD+9RncnXxU";
  systems.bender-1699622785 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGp0moUfm51cJ6oeTZ+KJcoQ9ildWyWm1/O6RUwi61UH";
  systems.bender = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGp0moUfm51cJ6oeTZ+KJcoQ9ildWyWm1/O6RUwi61UH";
  systems.all = [ systems._130-61-215-94 systems.bender-1699622785 systems.bender ];

  all = users.all ++ systems.all;

}
