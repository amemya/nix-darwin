{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "ls -la";
      ls = "eza --icons";
      cls = "clear";
      "えぃt" = "exit";
      rm = "gomi";
    } // lib.optionalAttrs pkgs.stdenv.isDarwin {
      nrs = "scutil --get LocalHostName > /tmp/.nix-darwin-hostname && sudo darwin-rebuild switch --flake ~/.config/nix-darwin --impure";
    } // lib.optionalAttrs pkgs.stdenv.isLinux {
      nrs = "hostname > /tmp/.nixos-hostname && sudo nixos-rebuild switch --flake ~/.config/nix-darwin --impure";
    };

    sessionVariables = {
      GPG_TTY = "$(tty)";
    } // lib.optionalAttrs pkgs.stdenv.isDarwin {
      STM32CubeMX_PATH = "/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources";
    };


    initContent = ''
      # PATH additions
      export PATH="$PATH:$HOME/go/bin"
      export PATH="$PATH:$HOME/.local/bin"
      export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

      # zsh options
      unsetopt nomatch

      # Custom functions
      mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      mkcdg() {
        mkcd "$1" && git init
      }
    '' + lib.optionalString pkgs.stdenv.isDarwin ''

      deploy-nixos() {
        if [ "$#" -ne 2 ]; then
          echo "Usage: deploy-nixos <user@ip> <hostname>"
          echo "Example: deploy-nixos amemiya@192.168.1.10 raspberrypi"
          return 1
        fi
        
        local TARGET="$1"
        local HOSTNAME="$2"
        
        echo "$HOSTNAME" > /tmp/.nixos-hostname
        echo "Evaluating on Mac and deploying to $TARGET ($HOSTNAME)..."
        nix run nixpkgs#nixos-rebuild -- switch --flake ~/.config/nix-darwin --target-host "$TARGET" --build-host "$TARGET" --use-remote-sudo --impure
      }
    '';
  };
}
