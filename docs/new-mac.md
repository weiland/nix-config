# fresh macOS installation

> nix-darwin, home-manager and dotfiles managed by nix.

> on a freshly clean mac machine (or macOS vm)

## Setup machine

### iCloud

During Setup:

1. Login in to iCloud
2. System Settings -> iCloud -> iCloud Drive: enable *Desktop & Documents Folders*.
3. Disable *Optimize Mac Storage* for Documents (and later in Photos, too), so all data will be downloaded.

### System Updates

Making sure system is up-to-date:

```bash
sudo softwareupdate --install --all --restart --verbose
```

### Xcode and Developer Tools

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

### Optional: Install Rosetta

If you use _AusweisApp.app_ or `terminal-notifier` you might still need it.

```fish
softwareupdate –install-rosetta
```


### Code directories

Create code directory if not yet existing.

In iCloud:

```bash
mkdir -p ~/Documents/Code/weiland
mkdir ~/Documents/Code/clones
mkdir ~/Documents/Code/tests
mkdir ~/Documents/Code/go
```

Local. Some code does not work due to iCloud syncing or some code does not need to be in the cloud:

```bash
mkdir -p ~/src/clones
mkdir -p ~/src/tests
```

### Install Homebrew

It can run independently but is later controlled via _nix-darwin_.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

The `brew` command will ba available later after applying the home-manager settings.

## Install nix and dotfiles

https://github.com/weiland/nix-config/blob/main/docs/installation.md


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
