{ ... }:
{
  nixpkgs.overlays = [
    (import ./bun.nix)
  ];
}
