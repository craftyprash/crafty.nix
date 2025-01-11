{ config, pkgs, lib, user, homeDirectory, ... }:

let
  # Fisher plugin list
  fishPlugins = {
    tmux = {
      name = "tmux";
      src = "budimanjojo/tmux.fish";
      detectFile = "tmux.fish";
    };
    tide = {
      name = "tide";
      src = "IlanCosman/tide@v6";
      detectFile = "_tide_init.fish";
    };
    autopair = {
      name = "autopair";
      src = "jorgebucaran/autopair.fish";
      detectFile = "autopair.fish";
    };
    fzf = {
      name = "fzf";
      src = "PatrickF1/fzf.fish";
      detectFile = "fzf.fish";
    };
    z = {
      name = "z";
      src = "jethrokuan/z";
      detectFile = "z.fish";
    };
    # Add other plugins here
  };

  # Create the fisher plugin installation script
  fishPluginScript = pkgs.writeText "install-fish-plugins.fish" ''
    # Disable greeting
    set -U fish_greeting

    echo "Installing fisher and plugins..." >&2

    # Ensure fisher is installed
    if not functions -q fisher
      curl -sL https://git.io/fisher | source
      fisher install jorgebucaran/fisher
    end

    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: plugin: ''
        # Installing ${name}
        if not test -e $__fish_config_dir/conf.d/${plugin.detectFile}
          echo "Installing ${plugin.name}..." >&2
          fisher install ${plugin.src}
        end
      '') fishPlugins
    )}
'';
in
{
  # Enable Fish shell
  programs.fish = {
    enable = true;
    loginShellInit = ''
      # Initialize mise if available
      if command -v mise > /dev/null
        mise activate fish | source
      end
    '';
  };

  # Add Fish to shells and set as default
  environment.shells = [ pkgs.fish ];

  # Fish shell configuration
  environment.variables = {
    # Add Homebrew and libpq paths for Fish
    fish_user_paths = lib.concatStringsSep " " [
      "$fish_user_paths"
      "/opt/homebrew/bin"
      "/opt/homebrew/opt/libpq/bin"
      "/opt/homebrew/opt/mysql-client/bin"
      "~/.local/bin"
    ];
  };

  # Run fish plugin installation during system activation
  system.activationScripts.postUserActivation.text = ''
    echo "Setting up Fish plugins..." >&2
    ${pkgs.fish}/bin/fish ${fishPluginScript}
  '';
}
