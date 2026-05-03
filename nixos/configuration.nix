{ config, pkgs, nixosHostname, ... }:

{
  imports =
    [ 
      # Include the results of the hardware scan for the specific machine.
      (./hardware + "/${nixosHostname}.nix")
    ];

  # Bootloader settings have been moved to hardware-specific configuration files

  # Include terminfo for all terminals (fixes xterm-ghostty not found when SSHing from Mac)
  environment.enableAllTerminfo = true;

  # networking.hostName is injected dynamically via flake.nix

  #swapfile
  swapDevices = [ { device = "/swapfile"; size = 4096; } ];
  zramSwap.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Allow passwordless sudo for the wheel group (amemiya)
  # This prevents lockouts since we don't have a password set
  security.sudo.wheelNeedsPassword = false;

  # Allow Mac to SSH into this NixOS machine
  users.users.amemiya.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIu8coW+p5AeBRx2KkxWSHJ92u3fwK3v2GP/spigFCGp"
  ];

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
