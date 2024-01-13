{ pkgs, ... }: {
  system = {

    defaults = {

      LaunchServices.LSQuarantine =
        false; # disable quarantine for downloaded files

      NSGlobalDomain = {
        _HIHideMenuBar = true; # Auto hide menu bar
        AppleInterfaceStyleSwitchesAutomatically = true;

        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 10;
        KeyRepeat = 1;

        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;

        # Disable automatic capitalization
        NSAutomaticCapitalizationEnabled = false;
      };

      dock = {
        autohide = true;
        orientation = "left";
        # show-recents = false;
        showhidden = true; # TODO: just testing
        static-only = true; # show only open applications
        tilesize = 48;
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
          NewWindowTarget = "PfHm";
          NewWindowTargetPath = "file://$HOME/";

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
          "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" =
            true;
        };
        "com.apple.desktopservices" = { # prevent .DS_Store creation.
          DSDontWriteUSBStores = true;
          DSDontWriteNetworkStores = true;
        };
        "com.apple.menuextra.clock" = {
          # TODO: does not work?
          DateFormat = "EEE d H:mm";
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
