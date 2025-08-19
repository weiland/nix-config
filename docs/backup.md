# Backup

> Files and paths

- [ ] fish history `cp ~/.local/share/fish/fish_history ~/Documents/Backups`
- [ ] zoxide history (optional) `cp ~/Library/Application\ Support/zoxide/db.zo ~/Documents/Backups`
- [ ] export crontab `crontab -l >> ~/Documents/Backups/crontab`
- [ ] export hosts file `cat /etc/hosts >> ~/Documents/Backups/hosts`
- [ ] Bear.app notes [`~/Library/Group Containers/9K33E3U3T4.net.shinyfrog.bear/Application Data/database.sqlite`](https://bear.app/faq/where-are-bears-notes-located/)
- [ ] PhotoBooth photos
- [ ] manually installed fonts (via _Font Book_)


If not synced (or logged in) and if app is even used:

- [ ] `~/Documents`
- [ ] Zed settings, keymaps and extensions
- [ ] VS Code settings and extensions
- [ ] Ghostty settings

More optional:

- [ ] leftover Screenshots (in `~/tmp`)
- [ ] _recenttracks_ `cp ~/.local/share/recenttracks.csv ~/Documents/Backups/recenttracks.csv`


## Before formatting

- [ ] __Downloads__ and __Desktop__ are empty
- [ ] __Documents__ and __Photos__ are all synced (and uploaded)
- [ ] sync Firefox (on another device, i.e. Phone, Tablet other computer) and Firefox Containers
- [ ] make sure that everything is synced to iCloud.
- [ ] TimaMachine backup completed successfully
- [ ] Other backups ran
- [ ] make sure everything in `~/Documents/Code/` is committed and _all_ branches are pushed (including this `nix-config` repo)
- [ ] `la ~/` and `tree ~/.config`
