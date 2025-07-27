{config, ...}: {
  system = {
    stateVersion = 6;

    activationScripts.postActivation.text = ''
      # Stop iTunes from responding to the keyboard media keys
      launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2>/dev/null

      # Use list view in all Finder windows by default
      # Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
      defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

      # show dock on both displays
      defaults write com.apple.Dock appswitcher-all-displays -bool true

      # Show the ~/Library folder
      chflags nohidden ~/Library

      # Disable emoji substitution
      defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false
    '';

    defaults = {
      LaunchServices.LSQuarantine = false; # disable quarantine for downloaded files

      NSGlobalDomain = {
        _HIHideMenuBar = false;

        AppleInterfaceStyleSwitchesAutomatically = true;

        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 18;
        KeyRepeat = 2;

        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;

        NSAutomaticWindowAnimationsEnabled = false;

        NSWindowResizeTime = 1.0e-3;

        # Disable automatic capitalization
        NSAutomaticCapitalizationEnabled = false;

        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;

        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;

        # NSDocumentSaveNewDocumentsToCloud = false; # TODO: test difference with icloud Documents.
      };

      dock = {
        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        expose-animation-duration = 0.1;
        largesize = 48;
        launchanim = false;
        magnification = false;
        mineffect = "scale";
        mru-spaces = false;
        orientation = "left";
        show-recents = false;
        showhidden = true; # TODO: just testing
        static-only = true; # show only open applications
        tilesize = 36;
      };

      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };

      finder.AppleShowAllExtensions = true;
      finder.AppleShowAllFiles = true;
      finder.FXDefaultSearchScope = "SCcf"; # search in current folder
      finder.FXPreferredViewStyle = "Nlsv";
      finder.FXEnableExtensionChangeWarning = false;
      finder.ShowPathbar = true;
      finder.ShowStatusBar = true;
      finder._FXShowPosixPathInTitle = true;

      loginwindow.GuestEnabled = false;
      loginwindow.LoginwindowText = "I dont have your cookies";
      loginwindow.SHOWFULLNAME = true;

      # menuExtraClock = {
      # ShowDayOfWeek = true;
      # ShowSeconds = true;
      # };

      screencapture = {
        disable-shadow = true;
        location = "/tmp";
      };

      CustomUserPreferences = {
        "net.sf.Jumpcut" = {
          launchOnStartup = true;
          checkForUpdates = true;
        };
        "com.knollsoft.Rectangle" = {
          hideMenubarIcon = 1;
          launchOnLogin = 1;
        };
        "com.flexibits.fantastical2.mac" = {
          WeeksPerQuarter = 12;
        };
      };

      CustomSystemPreferences = {
        NSGlobalDomain = {
          # Set the system accent color, TODO: https://github.com/LnL7/nix-darwin/pull/230
          # AppleAccentColor = 6;
          AppleHighlightColor = "215/255 51/255 119/255";
          # Jump to the spot that's clicked on the scroll bar, TODO: https://github.com/LnL7/nix-darwin/pull/672
          AppleScrollerPagingBehavior = true;
          # Prefer tabs when opening documents, TODO: https://github.com/LnL7/nix-darwin/pull/673
          AppleWindowTabbingMode = "always";

          # NSTableViewDefaultSizeMode = 2;
        };
        "com.apple.finder" = {
          ShowHardDrivesOnDesktop = false;
          ShowRemovableMediaOnDesktop = false;
          ShowExternalHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = false;

          # Show directories first
          _FXSortFoldersFirst = true;

          # New window use the $HOME path
          NewWindowTarget = "PfLo";
          #NewWindowTargetPath = "file://${config.system.primaryUser}/";

          # Allow text selection in Quick Look
          QLEnableTextSelection = true;
        };
        "com.apple.Safari" = {
          HomePage = "about:blank";
          # For better privacy
          UniversalSearchEnabled = false;
          SuppressSearchSuggestions = true;
          SendDoNotTrackHTTPHeader = true;

          # Disable auto open safe downloads
          AutoOpenSafeDownloads = false;

          # Enable Develop Menu, Web Inspector
          IncludeDevelopMenu = true;
          IncludeInternalDebugMenu = true;
          WebKitDeveloperExtras = true;
          WebKitDeveloperExtrasEnabledPreferenceKey = true;
          # ContentPageGroupIdentifier = {
          #   WebKit2DeveloperExtrasEnabled = true;
          # };
        };
        "com.apple.desktopservices" = {
          # prevent .DS_Store creation.
          DSDontWriteUSBStores = true;
          DSDontWriteNetworkStores = true;
        };
        "com.apple.menuextra.clock" = {
          # TODO: does not work?
          DateFormat = "EEE d H:mm";
        };
        "com.apple.TimeMachine" = {
          DoNotOfferNewDisksForBackup = true;
        };
      };
    };

    # defaults.trackpad.Clicking = true;
    # defaults.trackpad.Dragging = true;
    # defaults.trackpad.TrackpadThreeFingerDrag = true;

    # keyboard.enableKeyMapping = true
    # keyboard.remapCapsLockToEscape = true;
  };
}
