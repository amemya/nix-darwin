{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "ls -la";
      ls = "eza --icons";
      nrs = "sudo darwin-rebuild switch --flake ~/.config/nix-darwin";
      cls = "clear";
      "えぃt" = "exit";
      rm = "rm -i";
    };

    sessionVariables = {
      GPG_TTY = "$(tty)";
      STM32CubeMX_PATH = "/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resources";
    };

    profileExtra = ''
      # Homebrew
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';

    initContent = ''
      # PATH additions
      export PATH="$PATH:/Users/amemiya/go/bin"
      export PATH="$PATH:/Users/amemiya/.local/bin"
      export PATH="/Users/amemiya/.antigravity/antigravity/bin:$PATH"

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
