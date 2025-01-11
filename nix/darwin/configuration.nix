{ config, pkgs, user, homeDirectory, ... }: {
  # Import all configuration modules
  imports = [
    ./01-system.nix
    ./02-finder.nix
    ./03-homebrew.nix
    ./04-fish.nix
    ./05-dotfiles.nix
    ./06-ssh.nix
    ./07-mise.nix
    ./08-vscode.nix
  ];

  # Set hostname
  networking.hostName = "craftymac";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];
  users.users.${user} = {
    name = "${user}";
    home = "${homeDirectory}";
    shell = pkgs.fish; # Set fish as the default shell
  };

  # Activation script to set fish as default shell
  system.activationScripts.postActivation.text = ''
    echo "Setting fish as default shell for ${user}..." >&2
    sudo chsh -s ${pkgs.fish}/bin/fish ${user}
  '';

  # Keep in Nix:
  #    - Command line tools
  #    - Development tools that don't need GUI
  #    - Tools that you want to version control strictly

  # For programming languages and runtime environments:
  #    - Consider using `mise` (which you already have) instead of installing directly through either Nix or Homebrew
  #    - This gives you better version management per project
  #
  # - When in doubt about a GUI app, use Homebrew
  # - When in doubt about a CLI tool, use Nix
  #
  # CLI tools and development utilities via Nix
  environment.systemPackages = with pkgs; [
    # Shell utilities
    fish
    tmux
    zoxide
    fzf
    ripgrep
    fd
    eza
    bat

    # Git tools
    git
    ghq
    lazygit
    delta

    # Development tools
    vim
    neovim
    mise
    jq
    lazydocker
    mysql-client
    #libpq is installed via homebrew

    # Programming languages
    zig    # Zig compiler and toolchain
    zls    # Zig Language Server
    go
    rustup
    python3

    # Misc
    stow
  ];

  # Auto upgrade nix package and the daemon service
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';
  system.activationScripts = {
    preUserActivation.text = ''
      # System-level setup only
    '';
    postUserActivation.text = ''
      # System-level cleanup/finalization
    '';
  };

  # system.activationScripts.postActivation.text = ''
  #   echo "Post-activation phase started..." >&2
  #   echo "Current user: $USER" >&2
  #   echo "Home directory: $HOME" >&2
  #   echo "Current directory: $(pwd)" >&2
  # '';

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  system.stateVersion = 5;
}
