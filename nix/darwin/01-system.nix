{ config, pkgs, user, homeDirectory, ... }: {

  system.activationScripts.preUserActivation.text = ''
    echo "Setting up Screenshots folder..." >&2
    SCREENSHOT_DIR="${homeDirectory}/Pictures/Screenshots"
    mkdir -p "$SCREENSHOT_DIR"
    chown ${user}:staff "$SCREENSHOT_DIR"
  '';

  system.defaults.NSGlobalDomain = {
    # Keyboard settings
    InitialKeyRepeat = 10;
    KeyRepeat = 2;
    ApplePressAndHoldEnabled = false;

    NSAutomaticCapitalizationEnabled = false;

    # Mouse/Trackpad settings
    "com.apple.mouse.tapBehavior" = 1;

    # Function keys behavior
    "com.apple.keyboard.fnState" = true;

    # Show file extensions globally
    AppleShowAllExtensions = true;

    # Expand save panel by default
    NSNavPanelExpandedStateForSaveMode = true;
    NSNavPanelExpandedStateForSaveMode2 = true;

    # Expand print panel by default
    PMPrintingExpandedStateForPrint = true;
    PMPrintingExpandedStateForPrint2 = true;

    # Save to disk (not to iCloud) by default
    NSDocumentSaveNewDocumentsToCloud = false;

    # Display time with seconds
    AppleICUForce24HourTime = true;
  };

  # Trackpad settings
  system.defaults.trackpad = {
    Clicking = true;
    TrackpadRightClick = true;
  };

  # Dock settings
  system.defaults.dock = {
    autohide = true;
    tilesize = 36;
    mru-spaces = false;
    show-recents = false;
    expose-animation-duration = 0.1;
    expose-group-apps = true;
  };

  system.defaults.CustomUserPreferences = {
    "com.apple.finder" = {
      # Set home directory as startup window
      NewWindowTargetPath = "file://${homeDirectory}";
      NewWindowTarget = "PfHm";
      # Set search scope to directory
      FXDefaultSearchScope = "SCcf";
    };
    "com.apple.desktopservices" = {
      # Disable creating .DS_Store files in network an USB volumes
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
    "com.apple.controlcenter" = {
      BatteryShowPercentage = true;
      Bluetooth = 18;
    };
    "com.apple.Spotlight" = {
      MenuItemHidden = 1;
    };
    "com.apple.Siri" = {
      StatusMenuVisible = false;
    };
    "com.apple.screencapture" = {
      location = "${homeDirectory}/Pictures/Screenshots";
      type = "jpg";
    };
  };

}
