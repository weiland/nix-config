{ pkgs, ... }: {
  homebrew = {
    enable = true;

    # TODO: add option (at flake level) to skip homebrew update option
    caskArgs.no_quarantine = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    taps = [ "homebrew/cask-fonts" "homebrew/cask-versions" ];

    brews = [ "openconnect" ];

    casks = [
      "anki"
      "dash"
      "discord"
      # "eloston-chromium"
      "firefox-developer-edition"
      # "ipatool"
      "iterm2"
      "keyboard-cleaner"
      "jumpcut"
      # "lulu"
      "mactracker"
      "obsidian"
      "sf-symbols"
      "spotify"
      "rectangle"
      "signal"
      "sublime-text"
      "qgis"
      "qlcolorcode"
      "qlimagesize"
      "qlmarkdown"
      "qlstephen"
      "quicklook-json"
      "tor-browser"
      "utm"
    ];

    masApps = {
      ausweisapp = 948660805;
      fantastical = 975937182;
      icebuddy = 1595947689;
      Ivory = 6444602274;
      mela = 1568924476;
      Photomator = 1444636541;
      pixelmatorpro = 1289583905;
      reeder = 1529448980;
      Structured = 1499198946;
      things = 904280696;
      testflight = 899247664;
      Texifier = 458866234;
      # UrbanVPNDesktop = 1517772049;
      # WireGuard = 1451685025;
      xcode = 497799835;
    };
  };
}
