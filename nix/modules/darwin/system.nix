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
      tilesize = 64;
      largesize = 80;
      magnification = true;

      # bottom-left = Desktop, top-right = Notification Center
      # 1: Disabled 4: Desktop, 12: Notification Center
      wvous-tl-corner = 1;
      wvous-tr-corner = 12;
      wvous-bl-corner = 4;
      wvous-br-corner = 1;

      # trackpad gestures
      showMissionControlGestureEnabled = true;
      showDesktopGestureEnabled = true;
      showAppExposeGestureEnabled = true;
      showLaunchpadGestureEnabled = true;
    };

    finder = {
      # appearance and display
      FXPreferredViewStyle = "clmv";
      ShowPathbar = true;
      _FXEnableColumnAutoSizing = true;

      # sorting and arrangement
      _FXSortFoldersFirst = true;

      # search and new window
      FXDefaultSearchScope = "SCcf";

      # display
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;

      # desktop
      CreateDesktop = false;

      # applications
      QuitMenuItem = true;
    };

    trackpad = {
      ActuationStrength = 0;
      FirstClickThreshold = 1;
      SecondClickThreshold = 1;

      Clicking = true;
      TrackpadRightClick = false;
      TrackpadCornerSecondaryClick = 2;
      TrackpadThreeFingerDrag = false;

      # scroll and zoom
      TrackpadPinch = true;
      TrackpadRotate = true;
      TrackpadTwoFingerDoubleTapGesture = true; # smart zoom

      # swipe and gesture
      TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
      TrackpadFourFingerHorizSwipeGesture = 2;
      TrackpadFourFingerPinchGesture = 2;
      TrackpadFourFingerVertSwipeGesture = 2;
    };

    screencapture = {
      location = "~/Pictures/Screenshots"; # must create directory
    };

    WindowManager = {
      AppWindowGroupingBehavior = true;
      EnableTiledWindowMargins = false;
      EnableTilingByEdgeDrag = false;
      EnableStandardClickToShowDesktop = false;
      HideDesktop = false;
      StandardHideDesktopIcons = true;
      EnableTopTilingByEdgeDrag = false;
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
        TrackpadFiveFingerPinchGesture = 2; # 0: disabled, 2: mission control
      };
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true; # DS_Store
        DSDontWriteUSBStores = true; # DS_Store
      };
      "com.apple.loginwindow" = {
        TALLogoutSavesState = false;
      };
    };
  };
}
