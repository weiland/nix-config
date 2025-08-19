# nix-config

> nix-darwin (for setting up macOS), home-manager (for _dotfiles_ and settings) and _neovim_ configuration.

## Features

- [nix flakes](https://nixos.wiki/wiki/Flakes)
- nix-darwin
- home-manager (via _nix-darwin_ but could work as standalone as well)
- homebrew (via nix-darwin)
- neovim configuration (in lua)
- fish shell
- several dev-shells [WIP]

## Hosts / Machines / Devices

| Host     | Hardware      | named after                                                |
|----------|---------------|------------------------------------------------------------|
| `Kare`   | Apple silicon | [Susan Kare](https://en.wikipedia.org/wiki/Susan_Kare)     |
| `Hopper` | Apple silicon | [Grace Hopper](https://en.wikipedia.org/wiki/Grace_Hopper) |

My standard username is `pw`. All code will be placed in the `~/Documents/Code/` directory, which ideally already exsists.
Previously, all my code was stored in `~/src/`.
The standard machine/host is `Hopper` an `aarch64-darwin` laptop device.


## Docs

### Installation

Install `nix` and this repo (or parts of it) on a mac.

https://github.com/weiland/nix-config/blob/main/docs/installation.md

### Mac Setup

On a clean install and/or new machine.

https://github.com/weiland/nix-config/blob/main/docs/new-mac.md

### Updates and housekeeping

update `nix`, `nixpkgs`, `nix-darwin` and/or `home-manager` as well as managing
a _host_ or this repo code.

https://github.com/weiland/nix-config/blob/main/docs/updates.md

### Backup

https://github.com/weiland/nix-config/blob/main/docs/backup.md

## Previous dotfiles

My previous dotfiles (using gnu `stow`) can be found at https://github.com/weiland/dotfiles/tree/dotfiles
