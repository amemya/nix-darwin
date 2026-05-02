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
    '';
  };
}
