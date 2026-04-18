{ pkgs, ... }:

{
  # ──────────────────────────────────────────────
  # Network > Firewall
  # ──────────────────────────────────────────────
  networking.applicationFirewall.enable = true; # Firewall: on

  # ──────────────────────────────────────────────
  # Appearance: Auto (Light/Dark follows system)
  # ──────────────────────────────────────────────
  system.defaults.NSGlobalDomain.AppleInterfaceStyleSwitchesAutomatically = true;

  # ──────────────────────────────────────────────
  # Desktop & Dock
  # ──────────────────────────────────────────────
  system.defaults.dock = {
    tilesize = 50;                   # Size: 40
    magnification = true;
    largesize = 70;                  # Magnification size: 64
    mineffect = "scale";             # Minimize animation: Scale Effect
    minimize-to-application = true;  # Minimize windows into application icon
    autohide = true;                 # Auto-hide dock
    show-recents = false;
    expose-group-apps = true;        # More Gestures > App Exposé: on
  };

  # ──────────────────────────────────────────────
  # Lock Screen
  # ──────────────────────────────────────────────
  system.defaults.screensaver = {
    askForPassword = true;
    askForPasswordDelay = 5; # Require password: after 5 seconds
  };

  system.defaults.loginwindow = {
    # Show username and photo: off → show text field only
    SHOWFULLNAME = true;
  };

  # ──────────────────────────────────────────────
  # Keyboard
  # ──────────────────────────────────────────────
  system.keyboard = {
    enableKeyMapping = true;
    # CapsLock → Control (nix-darwin built-in)
    # Control → CapsLock は hidutil で postActivation に記述
    remapCapsLockToControl = true;
  };

  # ──────────────────────────────────────────────
  # Trackpad
  # ──────────────────────────────────────────────
  system.defaults.trackpad = {
    FirstClickThreshold = 0;  # Click: Light (0=Light, 1=Medium, 2=Firm)
    SecondClickThreshold = 0;
    Clicking = true;           # Tap to click: on
  };

  # ──────────────────────────────────────────────
  # Activation scripts (すべて postActivation に統合、必要に応じ sudo を使用)
  # ──────────────────────────────────────────────
  system.activationScripts.postActivation.text = ''
    echo "--- macos-settings: postActivation ---"

    # Keyboard: Control → CapsLock (reverse mapping via hidutil)
    # 0x700000039 = CapsLock, 0x7000000E0 = Left Control
    hidutil property --set '{"UserKeyMapping": [
      {"HIDKeyboardModifierMappingSrc": 0x700000039, "HIDKeyboardModifierMappingDst": 0x7000000E0},
      {"HIDKeyboardModifierMappingSrc": 0x7000000E0, "HIDKeyboardModifierMappingDst": 0x700000039}
    ]}' > /dev/null 2>&1 || true

    # Lock Screen: Turn Display off on battery when inactive: 5 min
    pmset -b displaysleep 5 2>/dev/null || true

    # Trackpad: Use Trackpad for Dragging on, Without Drag Lock
    sudo -u amemiya defaults write com.apple.AppleMultitouchTrackpad Dragging    -bool true
    sudo -u amemiya defaults write com.apple.AppleMultitouchTrackpad DragLock    -bool false
    sudo -u amemiya defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool true
    sudo -u amemiya defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock  -bool false

    # Keyboard: Press Fn key → Change input source (2)
    sudo -u amemiya defaults write com.apple.HIToolbox AppleFnUsageType -int 2

    # General > AirDrop: Everyone
    sudo -u amemiya defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

    # Displays: True Tone off
    sudo -u amemiya defaults write com.apple.CoreBrightness "AllowHDR" -bool false 2>/dev/null || true
  '';
}
