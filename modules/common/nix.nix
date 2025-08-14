{pkgs, ...}: {
  nix.settings = {
    experimental-features = "nix-command flakes";
  };

  nixpkgs.config = {
    allowUnfree = true;
    input-fonts.acceptLicense = true;
  };

  # Automatically run the nix store optimiser at a specific time.
  #nix.optimise.automatic = true;
  #nix.gc = {
  #  automatic = true;
  #  options = "--delete-older-than 14d";
  #};

  # manage nix with nix-darwin
  nix.enable = true;
  nix.package = pkgs.nix;
}
