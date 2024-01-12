{
  description = "Darwin flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin }: {

    darwinConfigurations."Kare" = nix-darwin.lib.darwinSystem {

      system = "aarch64-darwin";
      modules =
        [ home-manager.darwinModules.home-manager ./hosts/Kare/default.nix ];
    };
  };
}
