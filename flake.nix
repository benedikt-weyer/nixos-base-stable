{
  description = "Nixos config flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.05";
      #url = "https://channels.nixos.org/nixos-25.05/nixexprs.tar.xz";
    };

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
      #url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    };

    nixpkgs-24-11 = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-24-11,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = rec {
            inherit inputs;

            pkgs-unstable = import nixpkgs-unstable { 
              system = "x86_64-linux"; 
              config.allowUnfree = true; 
            };

            pkgs-custom = pkgs: {
              prisma-engines-up-to-date = pkgs.callPackage ./modules/custom-packages/prisma-engines/package.nix { 
                inherit pkgs pkgs-unstable; 
                lib = nixpkgs.lib;
              };
            };

            pkgs-24-11 = import nixpkgs-24-11 {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
          modules = [
            {
              nixpkgs.config.allowUnfree = true;
            }
            ./hosts/default/configuration.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
