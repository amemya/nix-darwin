{ config, pkgs, ... }: 

{
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
    };
  };
}