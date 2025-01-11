{ config, pkgs, ... }: {

  system.defaults.finder = {
    # Show file extensions
    AppleShowAllExtensions = true;

    # Disable extension change warning
    FXEnableExtensionChangeWarning = false;

    # Show path in title
    _FXShowPosixPathInTitle = true;

    # Search current folder by default
    FXDefaultSearchScope = "SCcf";

    # Show status bar
    ShowStatusBar = true;

    # Show path bar
    ShowPathbar = true;

    # Keep folders on top
    _FXSortFoldersFirst = true;

    # Show all files
    AppleShowAllFiles = true;

    # Hide recent tags
    ShowRecentTags = false;

    # Don't show tags
    TagsOnSidebar = false;

    # Empty trash securely
    # EmptyTrashSecurely = true;

    # Use list view by default
    FXPreferredViewStyle = "Nlsv";

  };

  # Activation script for Finder-specific items
  system.activationScripts.postUserActivation.text = ''
    echo "Configuring Finder settings..." >&2

    # Show Library folder
    chflags nohidden ~/Library

    # Show Volumes folder
    sudo chflags nohidden /Volumes
  '';
}
