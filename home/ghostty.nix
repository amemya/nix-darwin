{ config, pkgs, lib, ... }: 

lib.mkIf pkgs.stdenv.isDarwin {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;

    settings = {
      theme = "Chester";
      font-size = 14;
      font-family = "Hackgen Console NF";
      cursor-style = "block";
      window-padding-x = 10;
      window-padding-y = 10;
      term = "xterm-256color";
      macos-titlebar-style = "tabs";

      background-opacity = 0.7;
      background-blur = 13;
      unfocused-split-opacity = 0.6;
    };
  };
}
