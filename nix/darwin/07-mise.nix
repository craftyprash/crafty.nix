{ config, pkgs, lib, user, homeDirectory, ... }:

let
  miseSetupScript = pkgs.writeText "setup-mise.fish" ''
    # Install mise if not present
    if not command -v mise > /dev/null
      echo "Installing mise..." >&2
      curl https://mise.run | sh
    end

    # Ensure ~/.local/bin is in PATH
    set -gx PATH $HOME/.local/bin $PATH

    # Ensure mise is available after installation
    if not command -v mise > /dev/null
      echo "mise installation failed or not in PATH" >&2
      exit 1
    end

    # Trust the config file
    # echo "Trusting mise config files..." >&2
    # mise trust ~/.dotfiles/mise/.config/mise/config.toml

    echo "Installing development tools with mise..." >&2
    # Since config.toml is already linked via stow, just run mise install
    mise install || echo "Failed to install tools defined in config.toml" >&2

    # Install Java
    # mise install java@temurin-21
    # mise use -g java@temurin-21

    # # Install Maven
    # mise install maven@latest
    # mise use -g maven@latest

    # # Install Node.js LTS
    # mise install nodejs@lts
    # mise use -g nodejs@lts

    # Ensure mise is activated in fish
    mkdir -p ~/.config/fish/conf.d
    if not test -f ~/.config/fish/conf.d/mise.fish
      mise activate fish > ~/.config/fish/conf.d/mise.fish
    end
  '';
in
{
  system.activationScripts.postUserActivation.text = ''
    echo "Setting up mise..." >&2
    sudo -u ${user} ${pkgs.fish}/bin/fish ${miseSetupScript}
  '';
}
