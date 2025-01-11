{ config, lib, user, ... }: {
  # What belongs here?
  # - Any IDE or GUI editor
  # - Virtual machine managers
  # - Apps that need system privileges
  # - Apps that auto-update themselves

  #Use the homebrew module in nix-darwin to declaratively manage Homebrew packages
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    global = {
      brewfile = true;
      lockfiles = true;
    };

    # Taps
    taps = [
      # "homebrew/services"
      "hashicorp/tap"
      "nikitabobko/tap"
    ];

    # Homebrew Formulae (macOS-specific CLI tools)
    # Development tools that need system integration
    brews = [
      # Development tools
      "watchman"
      "libpq"
      "awscli"
      "terraform"
    ];

    # macOS-specific GUI apps installed via Homebrew Cask
    casks = [
      # Development tools
      "dbeaver-community"
      "tableplus"
      "docker" # System integration needed
      "bruno"
      "wezterm"
      "ghostty"
      "session-manager-plugin"

      # Editors
      "visual-studio-code"
      "zed"

      # System utilities
      "karabiner-elements"
      "aerospace" # Tiling WM
      "raycast"

      # Network tools
      "openvpn-connect"

      # Browsers
      "arc"

      # Media
      "vlc"
      "folx"

      # Productivity
      "obsidian"

      # Nerd Fonts
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-caskaydia-mono-nerd-font"
    ];

    # Mac App Store apps
    masApps = {};

  };

}
