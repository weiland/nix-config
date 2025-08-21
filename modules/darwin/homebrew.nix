{ ... }:
{
  homebrew = {
    enable = true;

    caskArgs.no_quarantine = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    taps = [
      # "oven-sh/bun"
    ];

    brews = [
      # "bun"
      # "llm"
      # "git-open"
      "gnupg"
      "nss"
      "openconnect"
      "pkl"
      "swift-format"
      "terminal-notifier"
    ];

    casks = [
      "1password"
      "1password-cli"
      "anki"
      "arc"
      "dash"
      "discord"
      "element"
      # "eloston-chromium"
      "firefox@developer-edition"
      "ghostty" # should installed via nix home-manager
      # "git-town"
      "google-chrome@dev"
      "iina"
      "intellij-idea"
      "iterm2"
      "jumpcut"
      "keyboard-cleaner"
      # "lulu"
      "mactracker"
      "marta"
      "mitmproxy"
      # "microsoft-edge@beta"
      # "mullvadvpn"
      "obsidian"
      "orbstack"
      # "qgis"
      # "pitch"
      "postgres-unofficial"
      "qlcolorcode"
      # "qlimagesize"
      "qlmarkdown"
      "qlstephen"
      "quicklook-json"
      "raycast"
      "rectangle"
      # "safe-exam-browser"
      "sf-symbols"
      "spotify"
      "signal"
      "sublime-text"
      "tor-browser"
      # "typora"
      # "ukelele"
      "utm"
      "vimr"
      "visual-studio-code"
      "zed"
      "zen"
      "zotero"
    ];

    # disable as long as mas cli is broken
    masApps = {
      AusweisAppBund = 948660805;
      Bear = 1091189122;
      Fantastical = 975937182;
      ICEBuddy = 1595947689;
      Ivory = 6444602274;
      Mela = 1568924476;
      #   MicrosoftExcel = 462058435;
      MicrosoftOutlook = 985367838;
      #   MicrosoftPowerPoint = 462062816;
      #   MicrosoftWord = 462054704;
      #   # OnePassword7 = 1333542190; # replaced with version 8
      Photomator = 1444636541;
      PixelmatorPro = 1289583905;
      Reeder = 1529448980;
      #   Slack = 803453959;
      #   Structured = 1499198946;
      Telegram = 747648890;
      Things = 904280696;
      TestFlight = 899247664;
      ToggleTrack = 1291898086;
      # StuffItExpander = 919269455;
      # Texifier = 458866234;
      #   # UrbanVPNDesktop = 1517772049;
      #   WireGuard = 1451685025;
      XCode = 497799835;
    };
  };
}
