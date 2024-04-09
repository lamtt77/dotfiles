{
  description = "TODO WIP LamT's flake: nix-darwin, home-manager configuration";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    nixpkgs.url                   = "github:nixos/nixpkgs/nixos-unstable";
    nur.url                       = "github:nix-community/NUR";
    stable.url                    = "github:nixos/nixpkgs/nixos-20.09";
    darwin.url                    = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager                  = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, darwin, home-manager, ... }:
    {
    darwinConfigurations."lamt-macbookpro" = darwin.lib.darwinSystem {
      modules = [
        ./darwin-configuration.nix
        home-manager.darwinModules.home-manager
      ];
      specialArgs = { inherit inputs nixpkgs; };
    };
    # TODO WIP linux nix os configuration
    nixosConfigurations = {
      Phil = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules =
          [ ./configuration.nix home-manager.nixosModules.home-manager ];
          specialArgs = { inherit inputs nixpkgs; };
        };
      };
    };
}
