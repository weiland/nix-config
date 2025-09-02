{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = {
    stateVersion = lib.mkForce "25.05";

    # Files
    # disable last login message
    file.".hushlogin".text = "";

    file.".curlrc".text = ''
      referer = ";auto"
      connect-timeout = 60
      max-time = 90
      remote-time
      show-error
      progress-bar
      user-agent = "Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0"
    '';

    # file.".gemrc".text = "gem: --no-document";

    # file."Library/Application Support/iTerm2/DynamicProfiles/Profiles.json".source = ../macos/iterm/Profiles.json;

    file.".local/bin" = {
      source = ../../data/bin;
      # recursive = true;
    };

    file.".ssh/allowed_signers".text = ''
      pasweiland@gmail.com,weiland@users.noreply.github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdCIgV4GeKOXvYs4aPCQ4li8/5xLu7cpIpWzJIsFkb9
    '';

    # Packages
    packages = with pkgs; [
      # Languages
      deno
      elixir
      elixir_ls
      rustup
      tree-sitter
      mise
      nodejs_24
      nodePackages.serve
      pnpm
      # (rWrapper.override{ packages = with rPackages; [ tidyverse knitr rtweet rmarkdown instaR ]; } ) # packages don't show up in DataSpell
      shellcheck

      # Tools
      age
      curl
      ffmpeg
      # fzf
      imagemagick
      just
      sops
      # qgis # not on macos

      # Container
      colima
      #docker
      #docker-compose
      #openconnect # fails
      podman
    ];

    # Session

    sessionPath = [
      "/opt/homebrew/bin/"
      "$HOME/.local/bin"
      "${config.home.homeDirectory}/.cache/cargo/bin"
    ];

    sessionVariables = {
      GOPATH = "$HOME/Documents/Code/go";

      DOCKER_SCAN_SUGGEST = "false";

      CARGO_HOME = "$HOME/.cache/cargo";
      RUSTUP_HOME = "$HOME/.config/rustup";

      MANPAGER = "nvim +Man!";

      # faster nodejs script loads (on disk caching)
      NODE_COMPILE_CACHE = "$HOME/.cache/nodejs-compile-cache";

      # XDG_CACHE_HOME  = "$HOME/.cache";
      # XDG_CONFIG_HOME = "$HOME/.config";
      # XDG_DATA_HOME   = "$HOME/.local/share";
      # XDG_STATE_HOME   = "$HOME/.local/state";
      XDG_BIN_HOME = "$HOME/.local/bin";

      STARSHIP_LOG = "error";
    };
  };
}
