{
  system,
  ...
}:
{
  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      input-fonts.acceptLicense = true;
      hostPlatform = system;
    };

    overlays = [
      (import ../overlays/pnpm.nix)
    ];
  };

  # Automatically run the nix store optimiser at a specific time.
  #nix.optimise.automatic = true;
  #nix.gc = {
  #  automatic = true;
  #  options = "--delete-older-than 14d";
  #};

  # manage nix (package/version) with nix-darwin
  # nix.enable = true; # enabled by default, will enable nix-daemon as well
  # nix.package = pkgs.nix; # is the default
  # nix.package = inputs.nixpkgs.legacyPackages.${system}.nix;
}
