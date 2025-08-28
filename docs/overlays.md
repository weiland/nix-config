# nix overlays

The overlays are placed in `./modules/overlays/` and then imported in `./modules/overlays/default.nix`
(which itself is imported at `./modules/common/nix.nix`).

## Test if my overlays are up to date

    $ ./scripts/outdated-overlays.ts

This script runs by default on nodejs v22.18 or v24 or higher (or on bun or deno).

## Fetch a new SRI hash

> [!NOTE]
> SRI (Subresource Integrity) hashes are used: https://www.w3.org/TR/sri/#introduction
> So a `nix-prefetch-url` might not be enough.
> More info: https://wiki.nixos.org/wiki/Nix_Hash

Example with a nodejs tar:

    $ nix store prefetch-file https://nodejs.org/dist/v24.7.0/node-v24.7.0.tar.xz

## Prefetch from GitHub

Example with `github:catppuccin/starship`:

$ nix run github:seppeljordan/nix-prefetch-github -- catppuccin starship
