{ config, pkgs, lib, user, homeDirectory, dotFilesRepo,... }:

let
  # Define google-java-format once
  google-java-format = pkgs.google-java-format;
  # If you need a specific version:
  # google-java-format = pkgs.google-java-format.override {
  #   version = "1.15.0";
  # };
in
{
  # User-specific configuration, running in user context

  # Enable home-manager
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";

  home.username = "${user}";
  home.homeDirectory = "${homeDirectory}";

  # Install google-java-format globally for both neovim and vscode
  home.packages = with pkgs; [
    google-java-format
  ];

}
