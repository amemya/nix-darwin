# Hardware configuration for Raspberry Pi 3B+
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # RPi 3B+ hardware:
  #   USB:      DWC2 controller (SoC built-in, shared with LAN7515)
  #   Ethernet: LAN7515 (USB-attached, driver: lan78xx)
  #   No PCIe, no VL805, no bcmgenet
  boot.initrd.availableKernelModules = [
    "dwc2"              # USB controller (BCM2837 DesignWare USB 2.0)
    "usbhid"            # USB keyboard/mouse HID
    "hid_generic"       # Generic HID fallback
    "lan78xx"           # LAN7515 USB Gigabit Ethernet
    "uas"               # USB Attached SCSI
    "usb_storage"       # USB mass storage
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "lan78xx" ];  # Ensure Ethernet is loaded at stage 2
  boot.extraModulePackages = [ ];

  # Bootloader for Raspberry Pi
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };

  swapDevices = [ ];

  # Use mainline kernel to avoid building the RPi kernel fork from source
  # (not in binary cache, exhausts VM disk space). Normal priority overrides
  # nixos-hardware's mkDefault while preserving its other settings.
  boot.kernelPackages = pkgs.linuxPackages;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
