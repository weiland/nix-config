# Installation

Install `nix` and this repo (with `nix-darwin`, `home-manager`, all macOS settings and dotfiles).

## Prerequisites

a mac machine with:

- command line developer tools
- repo location: `~/Documents/Code/nix-config`
- homebrew (`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`)

### Clone *nix-config* if not yet existing

By default we clone using `ssh` and with a custom ssh-key path at `~/Documents/Configs/ssh/id_pw`, (when there is none at `~/.ssh/id_ed` yet):

On a new system, the file modes might be lost, and have to be fixed so the keys can be accessed:

```bash
chmod 600 ~/Documents/Configs/ssh/id_pw
```

```bash
GIT_SSH_COMMAND='ssh -i ~/Documents/Configs/ssh/id_pw -o IdentitiesOnly=yes' git clone git@github.com:weiland/nix-config.git ~/Documents/Code/nix-config
```

<details>
<summary>other ways to clone (if ssh keys or GitHub are already setup):</summary>

Using `https` (may require a GitHub login):

  $ git clone https://github.com/weiland/nix-config.git ~/Documents/Code/nix-config

Using `ssh` (preferred, needs a ssh-key):

  $ git clone git@github.com:weiland/nix-config.git ~/Documents/Code/nix-config

</details>

<details>
<summary>If there is no git ...</summary>

You can follow the next step and install **nix** and then you can create a nix shell with `git` installed temporarely:

```bash
nix run nixpkgs#git

# or via old nix-env command
nix-env -iA nixpkgs.git
```
</details>

And now *cd* into the newly cloned `nix-config` directory:

	$ cd ~/Documents/Code/nix-config


## Install `nix` package manager

> [!NOTE]
> For `nix-darwin` [The Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer) is recommended, because it brinks flake-support by default, can easier remove nix, since nix-darwin manages nix itself and it can survive macOS upgrades.

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

> [!IMPORTANT]
> Make sure to install the __upstream Nix__ (and not the _Determinate Nix_ which happens when usign the `--determinate` flag during installation).

<details>
<summary>Alternatively, via the official nix installer:</summary>

```bash
sh <(curl -L https://nixos.org/nix/install)
```


If already in the fish shell, run:

```fish
sh (curl -L https://nixos.org/nix/install | psub)
```

Or, using [Lix Installer](https://lix.systems/install/#on-any-other-linuxmacos-system)

</details>


## Setup mac

This will apply the nix-darwin config and the home-manager config, so all mac default preferences will be set as well as all apps, tools and binaries will be installed.

```bash
# making sure to be in the right directory
cd ~/Documents/Code/nix-config
```

The following commands will install the host `Hopper`. Which can be replaced with any other hostname that exists in the `./hosts/` directory.

### For the first time

For the first time, the command `darwin-rebuild` is not yet installed in the `PATH`.

Install `nix-darwin` and _switch_ to the _Hopper_ darwin profile:

```bash
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#Hopper
```

After that the `darwin-rebuild` command is available and running `sudo darwin-rebuild switch --flake .#Hopper` works now.

<details>
<summary>__If not (yet) having _flakes___:</summary>

> because i.e. not using Determinate

```bash
sudo nix run --extra-experimental-features "nix-command flakes" nix-darwin -- switch --flake .#Hopper
```

You will need to enter your *sudo* password (at least once, perhaps more often as longer it takes) and click on *Allow* when prompted.

Now `nix-command` and `flakes` are enabled by default, so `--extra-experimental-features` can be omitted.


</details>


Restart mac (optional):

```bash
sudo reboot
```


### Update / Rebuild

```bash
sudo darwin-rebuild switch --flake .#Hopper

# for further times, one can use in any directory:
sudo darwin-rebuild switch --flake ~/Documents/Code/nix-config#Hopper
# of if the config lives in ~/.config/nix-config
sudo darwin-rebuild switch --flake ~/.config/nix-config#Hopper
```

> [!NOTE]
> Perhaps Full Disk Access is required. Enabled it in the _Privacy & Security_ System Settings for the current Terminal.


If you are on new system, you can now continue in [new-mac.md#finalisation](https://github.com/weiland/nix-config/blob/main/docs/new-mac.md#finalisation--app-preferences)
