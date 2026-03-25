{ inputs, ... }:
{
  nixpkgs.overlays = [
    (
      final: prev:
      let
        masterPkgs = import inputs.nixpkgs-master {
          inherit (final.stdenv) system;
          config.allowUnfree = true;
        };
      in
      {
        direnv = masterPkgs.direnv;
      }
    )
  ];
}
