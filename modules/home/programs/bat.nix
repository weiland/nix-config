{ ... }:
{
  programs.bat = {
    enable = true;
    config = {
      # NOTE: themes are managed in `themes.nix`
      theme = "catppuccin-latte";
      italic-text = "always";
    };
  };
}
