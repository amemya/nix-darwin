{ pkgs, lib, ... }:

{
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  users.users.amemiya = {
    shell = lib.mkDefault pkgs.zsh;
  } // lib.optionalAttrs pkgs.stdenv.isLinux {
    isNormalUser = true;
    description = "amemiya";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    name = "amemiya";
    home = "/Users/amemiya";
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
