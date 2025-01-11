{ config, pkgs, user, homeDirectory, ... }:

let
  # List of extensions to install
  extensions = [
    "bbenoist.nix"
    "vscodevim.vim"
    "rust-lang.rust-analyzer"
    "golang.go"
    "ziglang.vscode-zig"
    "esbenp.prettier-vscode"
    "bradlc.vscode-tailwindcss"
    "be5invis.toml"
    "GitHub.copilot"
    "GitHub.copilot-chat"
    "josevseb.google-java-format-for-vs-code"
    "jdinhlife.gruvbox"
    "johnpapa.vscode-peacock"
    "vscjava.vscode-java-pack"
  ];

  # Create a script to install extensions
  extensionsScript = pkgs.writeScript "install-vscode-extensions" ''
    #!/bin/bash

    # Ensure /usr/local/bin exists
    if [ ! -d "/usr/local/bin" ]; then
      echo "Creating /usr/local/bin directory..."
      sudo mkdir -p /usr/local/bin
    fi

    # Ensure the code command is available
    if [ ! -f "/usr/local/bin/code" ]; then
      echo "Installing 'code' command in /usr/local/bin..."
      sudo ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" "/usr/local/bin/code"
    fi

    # Wait a bit for the symlink to be available
    sleep 1

    echo "Installing VSCode extensions..."
    ${builtins.concatStringsSep "\n" (map (ext: ''
      if ! /usr/local/bin/code --list-extensions | grep -i "^${ext}$" &> /dev/null; then
        echo "Installing extension: ${ext}"
        sudo -u ${user} /usr/local/bin/code --install-extension ${ext}
      else
        echo "Extension already installed: ${ext}"
      fi
    '') extensions)}

    # Copy settings.json if it exists in our nix config
    if [ -f "${./vscode/settings.json}" ]; then
      echo "Copying settings.json..."
      sudo cp "${./vscode/settings.json}" "${homeDirectory}/Library/Application Support/Code/User/settings.json"
      sudo chown ${user}:staff "${homeDirectory}/Library/Application Support/Code/User/settings.json"
    fi

    echo "VSCode setup completed!"
  '';
in
{
  system.activationScripts.postUserActivation.text = ''
    echo "Setting up VSCode..." >&2
    ${extensionsScript}
  '';
}
