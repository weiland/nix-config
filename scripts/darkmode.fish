exit 1;

# In your config.fish
# set -l cache_file ~/.cache/fish_dark_mode
# set -l plist_file ~/Library/Preferences/.GlobalPreferences.plist

# Check if cache is newer than the preference file
if test -f $cache_file; and test $cache_file -nt $plist_file
    set -g is_dark_mode (cat $cache_file)
else
    # Cache is stale, update it
    if defaults read -g AppleInterfaceStyle >/dev/null 2>&1
        set -g is_dark_mode true
        echo true > $cache_file
    else
        set -g is_dark_mode false
        echo false > $cache_file
    end
end
