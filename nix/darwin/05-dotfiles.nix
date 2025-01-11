{ config, pkgs, lib, user, homeDirectory, secrets, ... }:

let
  # Define dotfiles paths
  dotfilesDir = "${homeDirectory}/.dotfiles";
  dotfilesRepo = "https://${secrets.github_token}@github.com/craftyprash/dotfiles.git";

  # export GITHUB_TOKEN="ghp_your_token_here"
  # darwin-rebuild switch --flake .#craftymac
  # dotfilesRepo = "https://${builtins.getEnv "GITHUB_TOKEN"}@github.com/craftyprash/dotfiles.git";

  # List of directories to stow
  stowPkgs = [
    "git"
    "aerospace"
    "ghostty"
    "aws"
    "bin"
    "karabiner"
    "wezterm"
    "tmux"
    "gem"
    "ssh"
    "fish"
    "nvim"
    "mise"
  ];
in
{
  system.activationScripts.postUserActivation.text = ''
    echo "Setting up dotfiles..." >&2

    # Clone or update dotfiles repository
    if [ ! -d "${dotfilesDir}" ]; then
      echo "Cloning dotfiles repository..." >&2
      ${pkgs.git}/bin/git clone ${dotfilesRepo} "${dotfilesDir}"
    else
      echo "Updating dotfiles repository..." >&2
      cd ${dotfilesDir} && ${pkgs.git}/bin/git pull
    fi

    # Create necessary directories if they don't exist
    mkdir -p ${homeDirectory}/.config

    # Remove existing Fish config to prevent conflicts
    echo "Removing existing Fish config..." >&2
    rm -f "${homeDirectory}/.config/fish/config.fish"

    # Change to dotfiles directory and stow everything
    cd ${dotfilesDir}
    for pkg in ${lib.concatStringsSep " " stowPkgs}; do
      echo "Stowing $pkg..." >&2
      ${pkgs.stow}/bin/stow -t ${homeDirectory} -R $pkg || {
        echo "Error: Failed to stow $pkg" >&2
        exit 1
      }
    done
  '';
}
