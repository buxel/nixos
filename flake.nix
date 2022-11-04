{
  description = "My personal NixOS configuration";

  inputs = {

    # Nix Packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # macOS Package Management
    darwin.url = "github:lnl7/nix-darwin/master";                              
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";                                   

    # Save state
    impermanence.url = "github:nix-community/impermanence";

  };

  outputs = { self, ... }@inputs: 
    
    with builtins;
    let inherit (self) outputs;
      # inherit (inputs.nixpkgs) lib;

      # Make a nixpkgs configuration
      mkPkgs = nixpkgs: system: import nixpkgs {
        inherit system;

        # Accept agreements for unfree software
        config.allowUnfree = true;
        config.joypixels.acceptLicense = true;

        # Include NIX User Repositories
        # https://nur.nix-community.org/
        config.packageOverrides = pkgs: {
          nur = import inputs.nur { pkgs = pkgs; nurpkgs = pkgs; };
        };
      };

      # Defaults for host, determine user directory from system
      host = override: 
        let inherit ({ system = "x86_64-linux"; username = "me"; } // override) system hostname username;
        in {
          inherit system hostname username;
          userdir = if (toString (tail (split "-" system))) == "darwin" then "/Users/${username}" else "/home/${username}";
        };

      # Make a NixOS host configuration
      mkHost = { hostname, system ? "x86_64-linux", username ? "me", userdir ? "${dir system}/${username}" }: 
        let host = { inherit hostname system username userdir; };
        in inputs.nixpkgs.lib.nixosSystem {
          system = system;
          pkgs = mkPkgs inputs.nixpkgs system;
          specialArgs = { inherit inputs outputs host; };
          modules = [ ./hosts/configuration.nix ];
        };

      # Make a Home Manager configuration
      mkHome = { hostname, system ? "x86_64-linux", username ? "me", userdir ? "${dir system}/${username}" }: 
        let host = { inherit hostname system username userdir; };
        in inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs inputs.nixpkgs system;
          extraSpecialArgs = { inherit inputs outputs host; };
          modules = [ ./hosts/home.nix ];
        };

    in {

      # My NixOS configurations
      nixosConfigurations = {
        cog    = mkHost (host { hostname = "cog"; });
        lux    = mkHost (host { hostname = "lux"; });
        nimbus = mkHost (host { hostname = "nimbus"; });
      };

      # My Home Manager configurations
      homeConfigurations = {
        cog    = mkHome (host { hostname = "cog"; });
        lux    = mkHome (host { hostname = "lux"; });
        nimbus = mkHome (host { hostname = "nimbus"; });
        umbra  = mkHome (host { hostname = "umbra"; system = "x86_64-darwin"; });
      };

    };
}
