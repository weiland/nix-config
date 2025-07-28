# nix-config

> nix-darwin, home-manager and dotfiles managed by nix.

## Features

- nix with [nix flakes](https://nixos.wiki/wiki/Flakes)
- nix-darwin
- home-manager (via nix-darwin but could work as standalone too)
- homebrew casks (via nix-darwin)
- several dev-shells [WIP]

## Machines

| Host     | Hardware     | named after                                                |
|----------|--------------|------------------------------------------------------------|
| `Kare`   | Apple Laptop | [Susan Kare](https://en.wikipedia.org/wiki/Susan_Kare)     |
| `Hopper` | Apple Laptop | [Grace Hopper](https://en.wikipedia.org/wiki/Grace_Hopper) |

My standard username is `pw`. All code will be placed in the `~/Documents/Code/weiland/` directory.
Previously, all my code was stored in `~/src/weiland`.

## Installation

> on a freshly clean mac machine

### Setup machine

#### iCloud

During Setup:

1. Login in to iCloud 
2. System Settings -> iCloud -> iCloud Drive: enable *Desktop & Documents Folders*.
3. Disable *Optimize Mac Storage* for Documents (and later in Photos, too), so all data will be downloaded.

#### System Updates

Making sure system is up-to-date:

```bash
sudo softwareupdate --install --all --restart --verbose
```

#### Xcode and Developer Tools

Install command line developer tools:

```bash
xcode-select --install
```
Then, install [**Xcode**](https://apps.apple.com/de/app/xcode/id497799835?mt=12&uo=4) from the App Store.

Now, _accept_ the _Xcode and SDK license_:

```bash
sudo xcodebuild -license accept
```

And make sure Xcode runs:

```bash
sudo xcodebuild -runFirstLaunch
```

Open **Xcode** go to _Preferences_, open the _Platforms_ tab and download iOS and VisioOS Simulators.

#### Install Rosetta

Actually, I try to avoid it, but looking at you _AusweisApp.app_

```fish
softwareupdate –install-rosetta
```


#### Code directories

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
```

<details>
<summary>other ways to clone (if ssh keys or GitHub are already setup):</summary>

```fish
# using ssh (with default key in ~/.ssh)
git clone git@github.com:weiland/nix-config.git ~/Documents/Code/weiland/nix-config

# or using default (i.e. login to GitHub)
git clone https://github.com/weiland/nix-config.git ~/Documents/Code/weiland/nix-config
```
</details>

<details>
<summary>If there is no git ...</summary>
(which is supposed to be there actually with ventura/sonoma and installed xcode dev-tools)

You can follow the next step and install **nix** and then you can create a nix shell with `git` installed temporarely:

```bash
nix run nixpkgs#git

# or via old nix-env command
nix-env -iA nixpkgs.git
```
</details>

And now *cd* into the newly cloned `nix-config` directory:

	$ cd ~/Documents/Code/weiland/nix-config

### Install nix package manager

Via the official nix installer:

```bash
sh <(curl -L https://nixos.org/nix/install)
```

<details>
<summary>Or using Determinate Nix Install / fish shell installation</summary>

Or using [The Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer), which performs well on mac (esp. after mac upgrades) and brings flake support by default:

```command
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

If already in the fish shell:

```fish
sh (curl -L https://nixos.org/nix/install | psub)
```

</details>

<details>
<summary>Enable flakes via config file</summary>

Not needed when using my home-manager config (or the Determinate Nix installer).

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

</details>

### Install Homebrew 

It can run independently but is later controlled via _nix-darwin_.


```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

The `brew` command will ba available later after applying the home-manager settings.

### Install mac with nix-darwin

This will apply the nix-darwin config and the home-manager config, so all mac default preferences will be set as well as all apps, tools and binaries will be installed.

```bash
# making sure to be in the right directory
cd ~/Documents/Code/weiland/nix-config
```

The following commands will install the host `Hopper`. Which can be replaced with any other hostname that exists in the `./hosts/` directory.

```bash
sudo nix run --extra-experimental-features "nix-command flakes" nix-darwin -- switch --flake .#Hopper
```

You have to enter your *sudo* password (at least once, perhaps more often as longer it takes) and click on *Allow* when prompted.

<details>
<summary>Or if using flakes remotely:</summary>

TODO(weiland): Fix command below

```bash
sudo nix flake --extra-experimental-features 'nix-command flakes' init -t github:weiland/nix-config#darwin
```
</details>

The next step is to **restart** the mac:

```bash
sudo reboot
```

Now `nix-command` and `flakes` are enabled by default, so `--extra-experimental-features` can be omitted.


### Update / Rebuild

Run again:

```bash
sudo darwin-rebuild switch --flake .#Hopper

# for further times, one can use in any directory:
sudo darwin-rebuild switch --flake ~/.config/nix-config#Hopper
```

(Perhaps Full Disk Access is required. Enabled it in the _Privacy & Security_ System Settings for the current Terminal.)

## Finalisation / App Preferences

### iterm

#### re-use config from `data/iterm/`

Set config:

    $ defaults write com.googlecode.iterm2 PrefsCustomFolder "/Users/pw/Documents/Code/nix-config/data/iterm"

Alternatively:

1. Open iterm2
2. General -> Preferences -> check *Load preferences from a custom folder or URL*
3. choose `/Users/pw/Documents/Code/weiland/nix-config/data/iterm`
4. And don't overwrite the existing one.

- [ ] Generally, allow *Full Disk Access* for iTerm in System Settings -> Privacy & Security

<details>
<summary>For pre Sonoma:</summary>
If no directory can be selected, iterm has no access to the hard disk.
This can be fixed by open `System Settings` -> Privacy & Security -> Hard Disk Access -> add _iterm2.app_.
</details>

<details>
<summary>Import a new colorscheme</summary>
#### Use a different colorscheme

Set colorscheme:

```fish
open ~/Documents/Code/weiland/nix-config/data/iterm/Oceanic-Next.itermcolors
```

Open any other additional _itermcolors_-file.

Other colorschemes for iterm can be found at: https://iterm2colorschemes.com
and should be downloaded to `data/iterm/`.
</details>

### Jumpcut

- [ ] Open & allow access (in _Privacy & Security_)

### Rectangle

- [ ] Open & allow access (in _Privacy & Security_) & choose recommended

### Trackpad

- [ ] Set _Tracking Speed_ to _Fast_

### Desktop & Dock

- [ ] _Click Wallpaper to reveal desktop_ to _Only in Stage Manager_

### Set up fish shell

- [ ] Import old fish history
```bash
[ -e ~/Documents/Backups/fish_history ] && cp ~/Documents/Backups/fish_history ~/.local/share/fish/fish_history
```
- [ ] Import _recenttracks.txt_ (or if new `mv ~/Downloads/recenttracks-*.csv ~/.local/share/recenttracks.csv`)
- [ ] Optionally: import z history file as well (for the same host) `~/Library/Application\ Support/zoxide/db.zo`

### Import English Keyboard Layout with Umlauts

- [ ] import keyboard layout
```fish
sudo cp -r data/keyboard_layout/ABC\ Extended\ German\ Umlauts.bundle /Library/Keyboard\ Layouts/
```
- [ ] restart mac 
- [ ] System Settings -> Keyboard -> Input Sources -> Edit -> + -> Others

### 1Password

- [ ] Allow Accessibility Settings (required for FF Browser extension to work)

### Firefox Developer Edition

- [ ] Login to Firefox Sync.
- [ ] Adjust Toolbar (remove spaces and unused icons)
- [ ] Login to Container Extension.
- [ ] Set DDG as default search engine
- [ ] Apply DuckDuckGo Settings: https://duckduckgo.com/?kae=-1&k18=1&kaj=m&kak=-1&kao=-1&kap=-1&kaq=-1&kau=-1&kav=1&kax=-1&kp=-2

### Internet Accounts / Mail

- [ ] Login to email accounts

### Fantastical

- [ ] Login via Apple (try a few times)
- [ ] add main calendar account.
- [ ] turn off notification from other calendars
- [ ] show calendar week numbers
- [ ] uncheck _Go to today after adding items_ in Advanced Settings 🤯

### Finder Sidebar

- [ ] Adjust items in Finder sidebar to: Recents, Documents, Applications, Downloads, home, TU Darmstadt
- [ ] hide tags
- [ ] Make sure filename extensions are shown.

### Messages

- [ ] Edit -> Substitutions -> uncheck _Emoji Substitutions_
- [ ] Start new messages from certain email (same goes for _FaceTime_)

<details>
<summary>To receive text messages on this mac device.</summary>
On the iPhone:
- Settings -> Messages -> Text Message Forwarding -> _Enable_ this Mac
</details>

### Other apps

- [ ] **Xcode**: Login dev account
- [ ] **TestFlight**: Download *Element X*
- [ ] **Element**: Login to matrix account & verify session
- [ ] **gh cli**: `gh auth login`: choose GitHub.com, ssh and login via browser
- [ ] **Signal**: Login & sync
- [ ] **Telegram**: Login
- [ ] **Discord**: Login
- [ ] **Tealdeer**: Update cache `tldr --update`
- [ ] **Ivory**: login to all accounts (`vis.social`, `chaos.social` and `det.social`)
- [ ] **Reeder**: _Login_ and _sync_ and __Sort__: Oldest first
- [ ] **Mela**: Set the right _Calendar_ and _Reminders_.
- [ ] **Dash**: Download Elixir, Vue, Swift and Node docs
- [ ] **Sublime Text**: Tools -> Install Package Control
- [ ] **Outlook**: Login and set Trans Pride Theme
- [ ] **Slack**: Login
- [ ] **Spotify**: Under _Display_ Preferences, disable _now-playing panel_
- [ ] **Spotify**: Disable the Song change notifications

### Hosts

- [ ] import from https://someonewhocares.org/hosts/ to `/etc/hosts`

### Siri / Voice

- [ ] Download the good Siri Voices for VoiceOver etc (Dansk, Norsk, French, German and English)

### Wallpapers and Screensavers

- [ ] Choose nice views

### Uninstall unused apps

- [ ] Remove GarageBand and iMovie
- [ ] System Settings -> General -> Storage -> Remove Audio lib (from Garage Band)

### Apple Wallet

- [ ] set up cards, address and hide email

### Import files from other/old device

<details>
<summary>via ssh using rsync:</summary>

```bash
# copy with archive and compress option
rsync -avz -e ssh old@device.local:~/Downloads ~/Downloads

# copying web projects but skipping node modules
rsync -avz -e ssh old@device.local:~/src ~/src --exclude node_modules
```

Or use _Finder_ for external hard drives or _AirDrop_.
</details>

## Wrapping up

### Disk encryption

> should be turned on by default

- [ ] System Settings -> Privacy & Security -> Turn On __FileVault__

- [ ] Also, make sure that __Find My Mac__ is enabled under _Apple ID__ -> _iCloud_.

### Time Machine

- Make sure excluded paths are set (General -> Time Machine)
- Plug in external hard drive and set the right volume


## Testing and verification

- [ ] system works after restart
- [ ] fish is default shell in iTerm
- [ ] git user is correct
- [ ] git commits work
- [ ] git push via ssh work

## Updates

### Keeping nix and their friends up to date

```bash
# in nix-config directory
nix flake update --commit-lock-file

# from somewhere else
nix flake update --flake ~/Documents/Code/weiland/nix-config
```

## Housekeeping

### Code formatting

Formatting nix files:

```fish
# using alejandra
nix fmt **/*.nix
```

## Backup for a new machine

- [ ] __Downloads__ and __Desktop__ are empty
- [ ] __Documents__ and __Photos__ are all synced (and uploaded)
- [ ] sync Firefox (on another device, i.e. Phone, Tablet other computer) and Firefox Containers
- [ ] backup fish history `cp ~/.local/share/fish/fish_history ~/Documents/Backups`
- [ ] zoxide history (optional) `cp ~/Library/Application\ Support/zoxide/db.zo ~/Documents/Backups`
- [ ] export crontab `crontab -l >> ~/Documents/Backups/crontab`
- [ ] backup _recenttracks_ `cp ~/.local/share/recenttracks.csv ~/Documents/Backups/recenttracks.csv` (or download new one)
- [ ] manually installed fonts (via _Font Book_)
- [ ] backup Bear notes [`~/Library/Group Containers/9K33E3U3T4.net.shinyfrog.bear/Application Data/database.sqlite`](https://bear.app/faq/where-are-bears-notes-located/)
- [ ] PhotoBooth photos
- [ ] VS Code settings and extensions
- [ ] optional: leftover Screenshots (in `~/tmp`)
- [ ] make a full time machine backup
- [ ] make sure everything in `~/Documents/Code/` is committed and _all_ branches are pushed (including this `nix-config` repo)
