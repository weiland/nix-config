{
  pkgs,
  ...
}:
{
  imports = [
    ./bat.nix
    ./fish.nix
    ./git.nix
    ./starship.nix
  ];

  home.packages = with pkgs; [
    comma
    git-open
    httpie
    htop
    hyperfine
    jq
    nmap
    nushell
    nix-output-monitor
    nix-your-shell
    pdfgrep
    sd # sed replacement
    tealdeer
    # terminal-notifier # --> works better via homebrew
    tig
    # wifi-password # was removed (but did not work any longer either) :c
    yt-dlp
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    herdr = {
      enable = true;
      settings = {
        onboarding = false;
        terminal = {
          default_shell = "nu";
          new_cwd = "follow";
          shell_mode = "auto";
        };
        theme = {
          auto_switch = true;
          dark_name = "catppuccin";
          light_name = "catppuccin-latte";
          name = "catppuccin";
        };
      };
    };

    mise = {
      enable = true;
    };
  };
}
