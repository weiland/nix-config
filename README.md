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


This install Xcode, and their tools such as *git*.

Login in to iCloud and enbale Documents Sync.

Disable *Optimize Mac Storage* for Documents (and later Photos), so all data will be downloaded.

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
mkdir ~/src/clones
mkdir ~/src/go
```

Clone *nix-config*

```bash
git clone http://github.com/weiland/nix-config.git ~/src/weiland/nix-config

# and cd into it
cd ~/src/weiland/nix-config
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
# or via flakes
nix shell nixpkgs#git
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
nix run nix-darwin -- switch --flake .#Kare

# of if not via flake
darwin-rebuild switch --flake .#Kare
```


## Finalisation

### iterm

Set colorscheme:

```fish
open ~/src/weiland/nix-config/data/iterm/Oceanic-Next.itermcolors
```

Other colorschemes for iterm can be found at: https://iterm2colorschemes.com
and should be downloaded to `data/iterm/`.


- Allow Full Disk Access

...

- Setup iterm config / Profile
- Copy old fish history
- Import recenttracks.txt

### Internet Accounts / Mail

Login to email accounts.


### Firefox Dev

Login to Firefox Sync.

Adjust Toolbar.


### Fantastical

Login via Apple and add main calendar.

### Import files from other/old device

#### via ssh and rsync

```bash
# copy with archive and compress option
rsync -avz -e ssh old@device.local:~/Downloads ~/Downloads

# copying web projects but skipping node modules
rsync -avz -e ssh old@device.local:~/src ~/src --exclude node_modules
```

### Finder sidebar

Adjust items in Finder sidebar.


### Login to `gh` cli

```command
gh auth login
```


### Spotify

Login.


### Ivory

login to accounts.


### Enable disk encryption

### Make first time machine backup


## Updates

```bash
nix flake update
```

## Housekeeping

### Code formatting

Formatting nix files:

```bash
nix run nixpkgs#nixfmt -- .
```

## Backup for a new machine

- fish history `cp ~/.local/share/fish/fish_history ~/Documents/Backups`
- zoxide history (optional)
- manually installed fonts
