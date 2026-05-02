{ config, pkgs, nixosHostname, ... }:

{
  imports =
    [ 
      # Include the results of the hardware scan for the specific machine.
      (./hardware + "/${nixosHostname}.nix")
    ];

  # Bootloader.
  # Adjust these according to your system's boot setup.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.consoleLogLevel = 3;

  # networking.hostName is injected dynamically via flake.nix

  #swapfile
  swapDevices = [ { device = "/swapfile"; size = 4096; } ];
  zramSwap.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # services.xserver.enable = false; # Disabled as GUI is not considered

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.amemiya = {
    isNormalUser = true;
    description = "amemiya";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # Zsh is required as default shell for the user
  # programs.zsh.enable = true; is now in modules/common.nix

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "25.11";
}
