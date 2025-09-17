{ ... }:
{
  nixpkgs.overlays = [
    (import ./bun.nix)
    # (import ./nodejs_24.nix)
    (import ./pnpm.nix)
  ];
}
