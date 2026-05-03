{ pkgs, ... }:

{
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  users.users.amemiya = {
    isNormalUser = true;
    description = "amemiya";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

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
