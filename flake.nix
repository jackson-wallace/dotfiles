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
        "jwallace@linux" = {
          system = "x86_64-linux";
          username = "jwallace";
        };
      };
    };
}
