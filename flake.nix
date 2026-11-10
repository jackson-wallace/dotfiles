{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    let
      home =
        {
          system,
          username,
          dxManagesClaude ? false,
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            ./home.nix
            ./claude.nix
          ];
          extraSpecialArgs = { inherit username dxManagesClaude; };
        };
    in
    {
      homeConfigurations = {
        "jwallace@Jwallace-Macbook16" = home {
          system = "aarch64-darwin";
          username = "jwallace";
          dxManagesClaude = true;
        };
        "jacks@mac" = home {
          system = "aarch64-darwin";
          username = "jacks";
        };
        "jwallace@linux" = home {
          system = "x86_64-linux";
          username = "jwallace";
        };
      };
    };
}
