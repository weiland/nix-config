{
  description = "Darwin flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
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

    darwinConfigurations."M11X0076" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules =
        [ home-manager.darwinModules.home-manager ./hosts/M11X0076/default.nix ];
    };

    homeConfigurations.M11X0076 = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "aarch64-darwin"; };
      modules =
        [ ./modules/home ./modules/neovim ];
    };

    homeConfigurations.pw-standalone = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "aarch64-darwin"; };
      modules = [ ./modules/home ./modules/neovim ];
    };

    # devShells.elixir1_15 = import ./modules/dev-shells/elixir1_15.nix;
  };
}
