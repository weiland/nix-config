{ config, pkgs, ... }:
{

  home = {
    stateVersion = "25.05";

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
      any-nix-shell
      curl
      colima
      ddev
      departure-mono
      deno
      #docker
      #docker-compose
      elixir
      elixir_ls
      entr
      # fd
      ffmpeg
      # fzf
      # git-open # is broken due to broken xdg-utils :c
      htop
      httpie
      # iamb
      imagemagick
      input-fonts
      julia-mono
      jq
      nerd-fonts.anonymice
      nerd-fonts.caskaydia-cove # Cascadia-Code
      nerd-fonts.commit-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.hasklug
      nerd-fonts.geist-mono
      nerd-fonts.monaspace
      nerd-fonts.blex-mono
      nerd-fonts.intone-mono
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      nerd-fonts.sauce-code-pro
      nerd-fonts.zed-mono
      nix-output-monitor
      nmap
      nodejs_24
      #openconnect # fails
      pdfgrep
      podman # trying out as docker replacement
      # ripgrep
      rustup
      # (rWrapper.override{ packages = with rPackages; [ tidyverse knitr rtweet rmarkdown instaR ]; } ) # packages don't show up in DataSpell
      shellcheck
      stow
      tealdeer
      # terminal-notifier # requires rosetta (and is rather old)
      tig
      tree-sitter
      wifi-password
      xan # xsv is not maintained :c
      yt-dlp

      yarn-berry
      # nix # comes with nix-darwin
      nodePackages.serve
      nodePackages.pnpm
      # qgis # not on macos
    ];

    # Session

    sessionPath = [
      "/opt/homebrew/bin/"
      "$HOME/.local/bin"
      "${config.home.homeDirectory}/.cache/cargo/bin"
    ];

    sessionVariables = {
      GOPATH = "~/src/go";

      DOCKER_SCAN_SUGGEST = "false";

      CARGO_HOME = "$HOME/.cache/cargo";
      RUSTUP_HOME = "$HOME/.config/rustup";

      MANPAGER = "nvim +Man!";

      # faster nodejs script loads (on disk caching)
      NODE_COMPILE_CACHE = "$HOME/.cache/nodejs-compile-cache";

      # XDG_CACHE_HOME  = "$HOME/.cache"; # is conflicting (but seems to already have the right value)
      # XDG_CONFIG_HOME = "$HOME/.config";
      # XDG_DATA_HOME   = "$HOME/.local/share";
      # XDG_STATE_HOME   = "$HOME/.local/state";
      XDG_BIN_HOME = "$HOME/.local/bin";

      STARSHIP_LOG = "error";
    };

  };

}
