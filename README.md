# CraftyNix

## Setup

1. Copy the secrets template nix/secrets.nix.example to nix/secrets.nix:
```bash
cp secrets.nix.example secrets.nix
```

2. Edit `secrets.nix` with your actual secret which is a GitHub token used to clone your dotfiles repository:
```nix
{
  github_token = "ghp_your_actual_token_here";
}
```
**Note:** `secrets.nix` is gitignored and won't be committed to the repository.

3. Run the setup:
```bash
chmod +x setup.sh
./setup.sh
```

4. Restart your terminal.

5. Run nix commands:
```bash
cd ~/crafty.nix/nix
nix run nix-darwin -- switch --flake .#craftymac
```


## Notes on manual setup

Terminal app should be allowed to access full disk (in System Settings → Privacy & Security → Full Disk Access)

Install Xcode Command Line Tools
```bash
xcode-select --install
```

Install Rosetta 2 manually (it will also be managed by nix-darwin later)
```bash
softwareupdate --install-rosetta --agree-to-license
```

Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Run the brew post install script and restart terminal.**

Install Nix
```bash
sh <(curl -L https://nixos.org/nix/install)
```

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Copy the nix folder to your home directory and from within the nix folder run:
```bash
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#craftymac

nix run nix-darwin -- switch --flake .#craftymac
```

**`nix-darwin` installs the command `darwin-rebuild`, subsequent rebuilds should use `darwin-rebuild`**

```bash
darwin-rebuild switch --flake .#craftymac
```

Remember to keep your `flake.lock` updated:
```bash
nix flake update
```
