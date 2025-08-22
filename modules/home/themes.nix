{ pkgs, ... }:
let
  catppuccin-fish = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "fish";
    rev = "6a85af2ff722ad0f9fbc8424ea0a5c454661dfed";
    hash = "sha256-Oc0emnIUI4LV7QJLs4B2/FQtCFewRFVp7EDv8GawFsA=";
  };
  rose-pine-fish = pkgs.fetchFromGitHub {
    owner = "rose-pine";
    repo = "fish";
    rev = "b82982c55582cfaf6f220de1893c7c73dd0cb301";
    hash = "sha256-Dvaw1k7XOU2NUQbTJAXPgAOPN1zTLVrc7NZDY5/KHeM=";
  };
  catppuccin-starship = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "starship";
    rev = "5906cc369dd8207e063c0e6e2d27bd0c0b567cb8";
    hash = "sha256-FLHjbClpTqaK4n2qmepCPkb8rocaAo3qeV4Zp1hia0g=";
  };
  rose-pine-starship = pkgs.fetchFromGitHub {
    owner = "rose-pine";
    repo = "starship";
    rev = "59e950643c2534075e36a144ed0056df3be353ab";
    hash = "sha256-0ZyV4P+yzbqBqO/+stjBAN6GblYEFHcv1TX1lWV2thM=";
  };
  catppuccin-bat = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "6810349b28055dce54076712fc05fc68da4b8ec0";
    sha256 = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
  };
  rose-pine-bat = pkgs.fetchFromGitHub {
    owner = "rose-pine";
    repo = "tm-theme";
    rev = "c4cab0c431f55a3c4f9897407b7bdad363bbb862";
    sha256 = "sha256-maQp4QTJOlK24eid7mUsoS7kc8P0gerKcbvNaxO8Mic=";
  };
in
{
  # fish themes will be placed at `~/.config/fish/themes`
  xdg.configFile."fish/themes/Catppuccin Frappe.theme".source =
    "${catppuccin-fish}/themes/Catppuccin Frappe.theme";
  xdg.configFile."fish/themes/Catppuccin Latte.theme".source =
    "${catppuccin-fish}/themes/Catppuccin Latte.theme";
  xdg.configFile."fish/themes/Catppuccin Macchiato.theme".source =
    "${catppuccin-fish}/themes/Catppuccin Macchiato.theme";

  xdg.configFile."fish/themes/Rosé Pine.theme".source = "${catppuccin-fish}/themes/Rosé Pine.theme";
  xdg.configFile."fish/themes/rose-pine-dawn.theme".source =
    "${rose-pine-fish}/themes/Rosé Pine Dawn.theme";
  xdg.configFile."fish/themes/rose-pine-moon.theme".source =
    "${rose-pine-fish}/themes/Rosé Pine Moon.theme";

  # Starship themes are config files
  # which we will write to `~/.config/starship/custom.toml`
  # Can be used via `set STARSHIP_CONFIG config` or `export STARSHIP_CONFIG=…`
  xdg.configFile."starship/catppuccin-frappe.toml".source =
    "${catppuccin-starship}/themes/frappe.toml";
  xdg.configFile."starship/catppuccin-macchiato.toml".source =
    "${catppuccin-starship}/themes/macchiato.toml";
  # full starship config (with frappe colors)
  xdg.configFile."starship/starship-light.toml".source = ../../data/starship-light.toml;

  xdg.configFile."starship/rose-pine-dawn.toml".source = "${rose-pine-starship}/rose-pine-dawn.toml";
  xdg.configFile."starship/rose-pine-moon.toml".source = "${rose-pine-starship}/rose-pine-moon.toml";
  xdg.configFile."starship/rose-pine.toml".source = "${rose-pine-starship}/rose-pine.toml";

  # bat themes
  # NOTE: the theme can be overwritten setting the `BAT_THEME` shell var.
  # programs.bat.config.theme = "catppuccin-latte"; # to set the theme
  programs.bat.themes = {
    catppuccin-latte = {
      src = catppuccin-bat;
      file = "themes/Catppuccin Latte.tmTheme";
    };
    catppuccin-macchiato = {
      src = catppuccin-bat;
      file = "themes/Catppuccin Macchiato.tmTheme";
    };
    rose-pine = {
      src = rose-pine-bat;
      file = "dist/themes/rose-pine.tmTheme";
    };
    rose-pine-dawn = {
      src = rose-pine-bat;
      file = "dist/themes/rose-pine-dawn.tmTheme";
    };
    rose-pine-moon = {
      src = rose-pine-bat;
      file = "dist/themes/rose-pine-moon.tmTheme";
    };
  };

  # ghostty has built in all themes from https://github.com/mbadolato/iTerm2-Color-Schemes
  # iterm config contains all themes used.

  # fd, eza, tree (using `LS_COLORS` var that we set without dircolors but `pkgs.vivid`)
  # programs.fish.shellInit = "set -x LS_COLORS \"(${lib.getExe pkgs.vivid} generate rose-pine-dawn)\"";
}
