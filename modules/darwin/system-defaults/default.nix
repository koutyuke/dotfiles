{ ... }:
{
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSTableViewDefaultSizeMode = 2;
      "com.apple.keyboard.fnState" = true;
      "com.apple.trackpad.forceClick" = false;
      "com.apple.trackpad.scaling" = 2.5;
      "com.apple.springing.delay" = 0.5;
      "com.apple.springing.enabled" = true;
    };

    dock = {
      autohide = true;
      tilesize = 65;
      largesize = 79;
      magnification = true;
      # bottom-left = Desktop, top-right = Notification Center
      wvous-bl-corner = 4;
      wvous-br-corner = 1;
      wvous-tr-corner = 12;
    };

    finder = {
      AppleShowAllFiles = true;
      CreateDesktop = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadRightClick = false;
      TrackpadThreeFingerDrag = false;
      FirstClickThreshold = 1;
      SecondClickThreshold = 1;
      ActuationStrength = 0;
    };

    screencapture = {
      location = "~/Downloads";
    };

    WindowManager = {
      EnableStandardClickToShowDesktop = false;
      HideDesktop = false;
      StandardHideDesktopIcons = true;
    };

    menuExtraClock = {
      ShowAMPM = true;
      ShowDate = 0;
      ShowDayOfWeek = true;
    };

    CustomUserPreferences = {
      ".GlobalPreferences" = {
        "com.apple.mouse.scaling" = 0.6875;
        "com.apple.scrollwheel.scaling" = 0.3125;
        "com.apple.sound.beep.flash" = 0;
      };
      "com.apple.AppleMultitouchTrackpad" = {
        TrackpadCornerSecondaryClick = 2;
        TrackpadThreeFingerTapGesture = 2;
        TrackpadFourFingerHorizSwipeGesture = 2;
        TrackpadFourFingerVertSwipeGesture = 2;
        TrackpadFourFingerPinchGesture = 2;
        TrackpadFiveFingerPinchGesture = 2;
        TrackpadTwoFingerDoubleTapGesture = 1;
        TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
      };
      "com.apple.WindowManager" = {
        EnableTiledWindowMargins = false;
        EnableTilingByEdgeDrag = false;
        EnableTopTilingByEdgeDrag = false;
        AppWindowGroupingBehavior = true;
      };
      "com.apple.dock" = {
        showAppExposeGestureEnabled = true;
      };
      "com.apple.loginwindow" = {
        TALLogoutSavesState = false;
      };
    };
  };
}
