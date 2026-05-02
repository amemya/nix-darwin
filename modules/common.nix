{ pkgs, ... }:

{
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable alternative shell support
  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Install Nerd Fonts
  fonts.packages = [
    pkgs.hackgen-nf-font
  ];
}
