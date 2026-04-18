{ pkgs, ... }:

{
  # ──────────────────────────────────────────────
  # Security: sudo with TouchID
  # ──────────────────────────────────────────────
  security.pam.services.sudo_local.touchIdAuth = true;

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
    tilesize = 50;                   # Size: 50
    magnification = true;
    largesize = 70;                  # Magnification size: 70
    mineffect = "scale";             # Minimize animation: Scale Effect
    minimize-to-application = true;  # Minimize windows into application icon
    autohide = true;                 # Auto-hide dock
    show-recents = true;             # Show suggested and recent apps in Dock
    expose-group-apps = false;      # Mission Control: アプリごとのグループ化 off

    # Hot Corners (1=無効, 2=MC, 3=AppWin, 4=Desktop, 10=画面消, 11=Apps/Launchpad, 12=通知センター, 13=ロック)
    wvous-tl-corner = 10; # 左上: Put Display to Sleep
    wvous-tr-corner = 12; # 右上: Notification Center
    wvous-bl-corner = 1;  # 左下: 無効
    wvous-br-corner = 11; # 右下: Apps (macOS 26で11はAppsに対応することを確認済み)

  };

  # ──────────────────────────────────────────────
  # Lock Screen
  # ──────────────────────────────────────────────
  system.defaults.screensaver = {
    askForPassword = true;
    askForPasswordDelay = 5; # Require password: after 5 seconds
  };

  system.defaults.loginwindow = {
    SHOWFULLNAME = false;
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

  # Tracking speed: 0.0 (Slow) 〜 3.0 (Fast)
  system.defaults.NSGlobalDomain."com.apple.trackpad.scaling" = 0.5; 

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
    # More Gestures > App Exposé: on (3本指スワイプ下で現在アプリのウィンドウ一覧)
    sudo -u amemiya defaults write com.apple.dock showAppExposeGestureEnabled -bool true

    # Lock Screen: Turn Display off on battery when inactive: 5 min
    # 確認: pmset -g custom | grep -A5 "Battery Power"
    pmset -b displaysleep 5 2>/dev/null || true

    # Trackpad: Use Trackpad for Dragging on, Without Drag Lock
    sudo -u amemiya defaults write com.apple.AppleMultitouchTrackpad Dragging    -bool true
    sudo -u amemiya defaults write com.apple.AppleMultitouchTrackpad DragLock    -bool false
    sudo -u amemiya defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool true
    sudo -u amemiya defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock  -bool false

    # Keyboard: Press Fn key → Change Input Source
    # 0=絵文字パレット, 1=入力ソース切り替え, 2=F1〜F12
    sudo -u amemiya defaults write com.apple.HIToolbox AppleFnUsageType -int 1
    # cfprefsd キャッシュをフラッシュして即時反映（しないと再ログインまで反映されない場合あり）
    sudo -u amemiya killall cfprefsd 2>/dev/null || true

    # General > AirDrop: Everyone
    sudo -u amemiya defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

    # Displays: True Tone off
    sudo -u amemiya defaults write com.apple.CoreBrightness "AllowHDR" -bool false 2>/dev/null || true
  '';
}
