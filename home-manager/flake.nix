{
  description = "Final's Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs@{ nixpkgs, home-manager, darwin }: {
    # linux
    nixosConfigurations = {
      tlserver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          {
            nixpkgs.overlays = [
              inputs.nur.overlay
              # (import ./overlays)
            ];
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.final = import ./home;
          }
        ];
      };
    };
  };

  # mac 
  darwinConfigurations = {
    finalserver = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.final = import ./home;
        }
      ];
    };
  };
}
