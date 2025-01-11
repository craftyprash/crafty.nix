{
  description = "MacOS system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager }:
  let
    system = "aarch64-darwin";
    user = "craftyprash";
    homeDirectory = "/Users/craftyprash";
    secrets = import ./secrets.nix;
  in {
    darwinConfigurations."craftymac" = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit user homeDirectory secrets; };  # Pass these variables to modules
      modules = [
        ./darwin/configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit user homeDirectory; };
          home-manager.users.${user} = import ./home/home.nix;
        }
      ];
    };
  };
}
