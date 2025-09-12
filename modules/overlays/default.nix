{ ... }:
{
  nixpkgs.overlays = [
    (import ./nodejs_24.nix)
    (import ./pnpm.nix)
  ];
}
