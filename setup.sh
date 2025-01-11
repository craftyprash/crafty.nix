#!/bin/bash

echo "Starting installation script..."

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Install Xcode Command Line Tools
echo "Checking for Xcode Command Line Tools..."
if ! command_exists xcode-select; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install

  # Wait for xcode-select installation to complete
  echo "Please wait for Xcode Command Line Tools installation to complete and press any key to continue..."
  read -n 1
else
  echo "Xcode Command Line Tools already installed"
fi

# Install Rosetta 2 (for Apple Silicon Macs)
echo "Checking if running on Apple Silicon..."
if [[ $(uname -m) == 'arm64' ]]; then
  # Check if Rosetta 2 is already installed
  if ! pkgutil --pkg-info com.apple.pkg.RosettaUpdateAuto > /dev/null 2>&1; then
      echo "Installing Rosetta 2..."
      /usr/sbin/softwareupdate --install-rosetta --agree-to-license
  else
      echo "Rosetta 2 is already installed"
  fi
else
  echo "Rosetta 2 not needed on this architecture"
fi

# Install Homebrew
echo "Checking for Homebrew..."
if ! command_exists brew; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for Apple Silicon Macs
  if [[ $(uname -m) == 'arm64' ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "Homebrew already installed"
fi

# Install Nix
echo "Checking for Nix..."
if ! command_exists nix; then
  echo "Installing Nix..."
  sh <(curl -L https://nixos.org/nix/install)

  mkdir -p ~/.config/nix
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

  # Source nix
  if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
      . ~/.nix-profile/etc/profile.d/nix.sh
  fi
else
  echo "Nix already installed"
fi

echo "Installation complete!"
echo "> Please restart your terminal to ensure all changes take effect and run the next cmd."
echo "> nix run nix-darwin -- switch --flake .#craftymac"
