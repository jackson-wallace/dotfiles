{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      home = { system, username }: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./home.nix ];
        extraSpecialArgs = { inherit username; };
      };
    in {
      homeConfigurations = {
        "jwallace@Jwallace-Macbook16" = home { system = "aarch64-darwin"; username = "jwallace"; };
        "jacks@mac" = home { system = "aarch64-darwin"; username = "jacks"; };
        "jwallace@linux" = home { system = "x86_64-linux"; username = "jwallace"; };
      };
    };
}
