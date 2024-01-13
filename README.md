# nix-config

> nix-darwin, home-manager and dotfiles managed by nix.

## Features

- nix flakes (no other nix channels)
- nix-darwin
- home-manager (via nix-darwin)
- homebrew casks (via nix-darwin)

`Kare` ist the hostname of this mac device, named after [Susan Kare](https://en.wikipedia.org/wiki/Susan_Kare).

## Installation

> on a freshly clean mac machine

### Setup machine


This install Xcode, and the tools such as *git*.

Login in to iCloud and enbale Documents Sync.

Updating system:

```bash
sudo softwareupdate -ia --verbose
```

Following steps are actually optional.

```bash
xcode-select --install
```

Then, install Xcode from the App Store.

```bash
sudo xcodebuild -license accept
```

```bash
sudo xcodebuild -runFirstLaunch
```

Create code directory:

```bash
mkdir -p ~/src/weiland
```

Clone *nix-config*

```bash
git clone ~/src/weiland/nix-config
```

### Install nix

```bash
sh <(curl -L https://nixos.org/nix/install)
```

or if using a fish shell

```fish
sh (curl -L https://nixos.org/nix/install | psub)
```

TODO: is optional

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Now you could use git via nix:

```bash
nix-env -iA nixpkgs.git
# or with flake
nix shell nixpkgs.git
```

### Install Homebrew 

which is controlled via nix-darwin later.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install nix-darwin

```bash
mkdir -p ~/src/weiland/nix-config
cd ~/src/weiland/nix-config
```

If using flakes remotely:

```bash
nix flake --extra-experimental-features 'nix-command flakes' init -t github:weiland/nix-config#darwin
```

```bash
nix build .#darwinConfigurations.Kare.system --extra-experimental-features "nix-command flakes"

# nix run nix-darwin -- switch --flake ~/.config/nix-darwin

# ./result/sw/bin/darwin-rebuild switch --flake .

nix run nix-darwin -- switch --flake .#Kare
```

### Rebuild / Update

```bash
darwin-rebuild switch --flake .#Kare
```


## Finalisation

...

- Setup iterm config
- Copy old fish history
- Import recenttracks.txt

## Housekeeping 

Formatting nix files:

```bash
nix run nixpkgs#nixfmt -- .
```