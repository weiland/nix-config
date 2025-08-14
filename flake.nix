{
  description = "Darwin flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:nix-darwin/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
  }: {
    darwinConfigurations."Hopper" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        ./hosts/Hopper/default.nix
          {
            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;
          }
      ];
    };

    homeConfigurations.pw-standalone = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {system = "aarch64-darwin";};
      modules = [
        ./modules/home
        ./modules/neovim
      ];
    };

    # devShells.elixir1_15 = import ./modules/dev-shells/elixir1_15.nix;
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.alejandra;
  };
}
