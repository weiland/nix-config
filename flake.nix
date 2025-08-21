{
  description = "Darwin flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
    }@inputs:
    let
      system = "aarch64-darwin";
    in
    {
      darwinConfigurations."Hopper" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit system;
            };
          }
          ./hosts/Hopper/default.nix
          {
            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;
          }
        ];
        specialArgs = { inherit inputs system; };
      };

      homeConfigurations.pw-standalone = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
        modules = [
          ./modules/home
          ./modules/neovim
        ];
      };

      # devShells.elixir1_15 = import ./modules/dev-shells/elixir1_15.nix;
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
