# Themes

## General overview

- https://github.com/mbadolato/iTerm2-Color-Schemes
    - large collection
- https://tinted-theming.github.io/tinted-gallery/
    - formerly https://github.com/tinted-theming/tinted-iterm2?tab=readme-ov-file
        - formerly https://github.com/chriskempson/base16-iterm2?tab=readme-ov-file

## Themes I use

- Rosé Pine
    - Dawn for light mode
    - Moon for dark mode
- Catppuccin
    - Latte for light mode
    - Macchiato for dark mode

## Themes I used to use

from old to latest:

- Ocean (base16)
- Nord (base16)
- Oceanic Next (base16)
- Oceanic Material (base24)


## Ohter nice themes

- One Dark (Atom)
- Tomorrow Night (Atom)
- ayu Mirage
- Gruvbox
- GitHub Light

## MacOS dark mode

If dark mode is explicitly activated/set

```bash
defaults read -g AppleInterfaceStyle
```

will return `Dark`.

On light mode, or on auto mode during the day (`AppleInterfaceStyleSwitchesAutomatically = 1;`)
the `AppleInterfaceStyle` value is not available and the command above returns nothing to _stdout_,
and an error message to _stderr_.

<details>
    <summary>read directly from plist</summary>

    ### read directly from plist

    Perhaps not the best approach.

    Instead of using `defaults` we could use

    ```bash
    plutil -extract AppleInterfaceStyle raw ~/Library/Preferences/.GlobalPreferences.plist
    ```

    to read the value.

    However, here stderr is not used, and the error message in stdout.
</details>

### Caching

In order to make the dark mode detection faster, we should utilize caching,
since file access can be faster than reading from `defaults`.



## Where to set themes

### Terminal

- iterm2
- ghostty

### Shell

- fish
- starship
- `LS_COLORS` (for ls, eza, tree, fd etc)
- bat

### Editors

- neovim
- Zed

Note on themes:

Rosé Pine Dawn has a slightly too bright orange color (for light background).
