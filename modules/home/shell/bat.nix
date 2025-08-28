{ ... }:
{
  programs.bat = {
    enable = true;
    config = {
      # NOTE: themes are managed in `themes.nix`
      # theme is set via `BAT_THEME`
      theme = "catppuccin-macchiato";
      italic-text = "always";
    };
  };
}
