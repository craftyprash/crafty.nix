{ config, pkgs, user, homeDirectory, ... }:

let
  sshSetupScript = pkgs.writeText "setup-ssh.fish" ''
    echo "Configuring SSH keys and permissions..." >&2

    # Ensure directories exist with correct permissions
    mkdir -p ${homeDirectory}/.ssh/keys ${homeDirectory}/.ssh/pem
    chmod 700 ${homeDirectory}/.ssh
    chmod 700 ${homeDirectory}/.ssh/keys ${homeDirectory}/.ssh/pem

    # Set permissions for specific SSH keys
    for key in "${homeDirectory}/.ssh/keys/id_mintifi_ed25519" "${homeDirectory}/.ssh/keys/github_ed25519" "${homeDirectory}/.ssh/keys/github_rsa" "${homeDirectory}/.ssh/keys/id_rsa_personal"
      if test -f $key
        echo "Setting permissions for $key" >&2
        chmod 600 $key
      end
    end

    # Set permissions for PEM files
    if test -d "${homeDirectory}/.ssh/pem"
      echo "Setting permissions for PEM files" >&2
      find "${homeDirectory}/.ssh/pem" -name "*.pem" -type f -exec chmod 600 {} \;
    end

    # Add SSH keys to keychain
    echo "Adding SSH keys to keychain..." >&2
    for key in "${homeDirectory}/.ssh/keys/id_mintifi_ed25519" "${homeDirectory}/.ssh/keys/github_ed25519" "${homeDirectory}/.ssh/keys/github_rsa" "${homeDirectory}/.ssh/keys/id_rsa_personal"
      if test -f $key
        echo "Adding SSH key to keychain: $key" >&2
        sudo -u "${user}" ssh-add --apple-use-keychain $key 2>/dev/null || true
      else
        echo "SSH key not found: $key (skipping)" >&2
      end
    end
  '';
in
{
  system.activationScripts.postUserActivation.text = ''
    echo "Setting up SSH..." >&2
    ${pkgs.fish}/bin/fish ${sshSetupScript}
  '';
}
