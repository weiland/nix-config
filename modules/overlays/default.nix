{ ... }:
{
  nixpkgs.overlays = [
    (import ./bun.nix)
    (import ./pnpm.nix)
  ];
}
