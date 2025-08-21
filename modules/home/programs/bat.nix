{ ... }:
{
  programs.bat = {
    enable = true;
    config = {
      # NOTE: themes are managed in `themes.nix`
      theme = "catppuccin-macchiato";
      italic-text = "always";
    };
  };
}
