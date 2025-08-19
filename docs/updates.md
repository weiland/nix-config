# Updates and housekeeping

## Keeping nix and friends up to date

```bash
# in nix-config directory
nix flake update --commit-lock-file

# or from somewhere else
nix flake update --flake ~/Documents/Code/weiland/nix-config
```

After that run `nix-darwin` again:

```bash
sudo darwin-rebuild switch --flake .#Hopper
```

This is supposed to update the `nix` version.


## Cleaning up

Delete old profile generations and unreachable objects from nix store.

```bash
sudo nix-collect-garbage --delete-older-than 10d

# or
nix-collect-garbage --delete-old
```

Optimise nix store:

```bash
nix-store --optimise -v
```

## Code formatting

Formatting nix files using `alejandra`:

```bash
nix fmt **/*.nix

# or
nix fmt .
```
