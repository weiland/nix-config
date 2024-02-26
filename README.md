# nix-config

> nix-darwin, home-manager and dotfiles managed by nix.

## Features

- nix flakes (no other nix channels)
- nix-darwin
- home-manager (via nix-darwin)
- homebrew casks (via nix-darwin)
- several dev-shells [WIP]

## Defaults

`Kare` ist the hostname of this mac device, named after [Susan Kare](https://en.wikipedia.org/wiki/Susan_Kare).
My standard username is `pw`. All code will be placed in the `~/Documents/Code/weiland/` directory.


## Installation

> on a freshly clean mac machine


### Setup machine

1. Login in to iCloud 
2. System Settings -> iCloud -> iCloud Drive: enable *Desktop & Documents Folders*.
3. Disable *Optimize Mac Storage* for Documents (and later Photos), so all data will be downloaded.

Making sure system is up to date:

```bash
sudo softwareupdate --install --all --restart --verbose
```

Install command line developer tools:

```bash
xcode-select --install
```

Then, install [**Xcode**](https://apps.apple.com/de/app/xcode/id497799835?mt=12&uo=4) from the App Store.

Now, _accept_ the _Xcode and SDK license_:

```bash
sudo xcodebuild -license accept
```

Note: You have to repeat this, after every Xcode update via the App Store.


And make sure Xcode runs:

```bash
sudo xcodebuild -runFirstLaunch
```

Optionally, open **Xcode** and install _Platforms_ via the _Preferences_.


Create code directory:

```bash
mkdir -p ~/Documents/Code/weiland
mkdir ~/Documents/Code/clones
mkdir ~/Documents/Code/tests
mkdir ~/Documents/Code/go
```

#### Clone this *nix-config*

On a new system, the file modes might be lost, and have to be fixed so the keys can be accessed:

```fish
chmod 600 ~/Documents/Configs/ssh/id_pw
```

Now we can clone. In order to prevent password prompts and because there is no `~/.ssh` directory yet with key pairs, we start with a different key path:

```fish
GIT_SSH_COMMAND='ssh -i ~/Documents/Configs/ssh/id_pw -o IdentitiesOnly=yes' git clone git@github.com:weiland/nix-config.git ~/Documents/Code/weiland/nix-config

# using ssh (with default key in ~/.ssh)
git clone git@github.com:weiland/nix-config.git ~/Documents/Code/weiland/nix-config

# or using default (i.e. login to GitHub)
git clone https://github.com/weiland/nix-config.git ~/Documents/Code/weiland/nix-config
```

And now *cd* into the newly cloned `nix-config` directory:

	$ cd ~/Documents/Code/weiland/nix-config


<details>
<summary>If there is no git ...</summary>
(which is supposed to be there actually with ventura/sonoma and installed xcode dev-tools)

You can follow the next step and install **nix** and then you can create a nix shell with `git` installed temporarely:

```bash
nix-env -iA nixpkgs.git

# or via nix flakes
nix run nixpkgs#git
```

</details>


### Install nix pac

Via the official nix installer:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

Or using [The Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer), which performs well on mac (esp. after mac upgrades) and brings flake support by default:

```command
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

<details>
<summary>or if using a fish shell</summary>

```fish
sh (curl -L https://nixos.org/nix/install | psub)
```

</details>

<details>
<summary>### Optionally enable _flakes_ and `nix-command`</summary>

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

</details>


### Install Homebrew 

Which is controlled via *nix-darwin* later, but can also be used independently.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```


### Install mac with nix-darwin

This will apply the nix-darwin config and the home-manager config, so all mac default preferences will be set as well as all apps, tools and binaries will be installed.

```bash
# making sure to be in the right directory
cd ~/Documents/Code/weiland/nix-config
```

The following commands will install the host `Hopper`. Which can be replaced with any other hostname that is configured in `./hosts/`.

```bash
nix run --extra-experimental-features "nix-command flakes" nix-darwin -- switch --flake .#Hopper
```

You have to enter your *sudo* password (at least once, perhaps more often as longer it takes) and click on *Allow* when prompted.

<details>
<summary>Or if using flakes remotely:</summary>

```bash
nix flake --extra-experimental-features 'nix-command flakes' init -t github:weiland/nix-config#darwin
```
</details>

The next step is to **restart** the mac:

```bash
sudo reboot
```

Now `nix-command` and `flakes` are enabled by default, so `--extra-experimental-features` can be omitted.


### Rebuild / Update

Run again:

```bash
nix run nix-darwin -- switch --flake .#Hopper

# for further times, one can use in any diectory:
nix run nix-darwin -- switch --flake ~/.config/nix-darwin#Hopper
```

(Perhaps Full Disk Access is required.)

## Finalisation

### iterm

#### re-use config from `data/iterm/`

1. Open iterm2
2. General -> Preferences -> check *Load preferences from a custom folder or URL*
3. choose `/Users/pw/Documents/Code/weiland/nix-config/data/iterm`
4. And don't overwrite the existing one.

For Pre-Sonoma: If no directory can be selected, iterm has no access to the hard dist. This can be fixed by open `System Settings` -> Privacy & Security -> Hard Disk Access -> add _iterm2.app_.

Generally, allow *Full Disk Access* for iTerm in System Settings -> Privacy & Security

#### Use a different colorscheme

Set colorscheme:

```fish
open ~/Documents/Code/weiland/nix-config/data/iterm/Oceanic-Next.itermcolors
```

Open any other additional _itermcolors_-file.

Other colorschemes for iterm can be found at: https://iterm2colorschemes.com
and should be downloaded to `data/iterm/`.


### Set up fish shell

- Copy old fish history
```bash
[ -e ~/Documents/Backups/fish_history ] && cp ~/Documents/Backups/fish_history ~/.local/share/fish/fish_history
```
- Import _recenttracks.txt_ (or if new `mv ~/Downloads/recenttracks-mo_ceol-1*.csv ~/.local/share/recenttracks.csv`)


### Internet Accounts / Mail

Login to email accounts.


### Firefox Dev

Login to Firefox Sync.

Adjust Toolbar.

Add missing extensions.

Login to Container Extension.

Apply DuckDuckGo Settings: https://duckduckgo.com/?kae=-1&k18=1&kaj=m&kak=-1&kao=-1&kap=-1&kaq=-1&kau=-1&kav=1&kax=-1&kp=-2


### Fantastical

Login via Apple and add main calendar account.


### Import files from other/old device

via ssh and rsync:

```bash
# copy with archive and compress option
rsync -avz -e ssh old@device.local:~/Downloads ~/Downloads

# copying web projects but skipping node modules
rsync -avz -e ssh old@device.local:~/src ~/src --exclude node_modules
```

Or use _Finder_ for external hard drives.


### Finder sidebar

- Adjust items in Finder sidebar.
- Make sure file extensions are shown.


### Login to `gh` cli

```command
gh auth login
# choose ssh and login via browser
```


### Element X

- Download via Testflight
- sign in an verify session


### Messages

Receive text messages on this mac device. On the iPhone:

Settings -> Messages -> Text Message Forwarding -> _Enable_ this Mac


### Spotify

- Login.
- Under _Display_ Preferences, disable _now-playing panel_


### Ivory

login to all accounts (`vis.social`, `chaos.social` and `det.social`)


### Reeder

- Open and sync.
- Sort: Oldest first


### Mela

Set the right _Calendar_ and _Reminders_.


### Disk encryption

System Settings -> Privacy & Security -> Turn On __FileVault__

Also, make sure that __Find My Mac__ is enbaled under _Apple ID__ -> _iCloud_.


### Time Machine

- Make sure excluded paths are set (General -> Time Machine)
- Plug in external hard drive and set the right volume


## Updates

### Keeping nix and their friends up to date

```bash
# in nix-config directory
nix flake update

# from somewhere else
nix flake update --flake ~/Documents/Code/weiland/nix-config
```


## Housekeeping

### Code formatting

Formatting nix files:

```bash
nix run nixpkgs#nixfmt -- .
```

## Backup for a new machine

- [ ] __Downloads__ and __Desktop__ are empty
- [ ] __Documents__ and __Photos__ are all synced (and uploaded)
- [ ] sync Firefox (on another device, i.e. Phone, Tablet other computer) and Firefox Containers
- [ ] backup fish history `cp ~/.local/share/fish/fish_history ~/Documents/Backups`
- [ ] zoxide history (optional)
- [ ] export crontab `crontab -l >> ~/Documents/Backups/crontab`
- [ ] commit all changes and push all branches of this repo
- [ ] backup _recenttracks_ `cp ~/.local/share/recenttracks.csv ~/Documents/Backups/recenttracks.csv`
- [ ] manually installed fonts (via _Font Book_)
- [ ] make a full time machine backup
- [ ] make sure everything in `~/Documents/Code/` is committed and _all_ branches are pushed