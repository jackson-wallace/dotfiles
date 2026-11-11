{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixos-hardware,
      ...
    }:
    let
      home =
        _:
        {
          system,
          username,
          isWork ? false,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./home
          ];
          extraSpecialArgs = { inherit username isWork; };
        };
    in
    {
      homeConfigurations = builtins.mapAttrs home {
        "jwallace@Jwallace-Macbook16" = {
          system = "aarch64-darwin";
          username = "jwallace";
          isWork = true;
        };
        "jacks@mac" = {
          system = "aarch64-darwin";
          username = "jacks";
        };
      };

      nixosConfigurations.xps = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/xps/configuration.nix
          nixos-hardware.nixosModules.dell-xps-13-7390
          home-manager.nixosModules.home-manager
          {
            home-manager.users.jackson.imports = [
              ./home
              ./home/sway.nix
            ];
            home-manager.extraSpecialArgs = {
              username = "jackson";
              isWork = false;
            };
            home-manager.backupFileExtension = "hm-bak";
          }
        ];
      };
    };
}
