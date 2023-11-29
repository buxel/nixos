{
  host = "bender"; 
  domain = "pingbit.de"; 
  user = "me"; 
  system = "aarch64-linux";
  config = {
    modules.secrets.enable = true;
  };
}
