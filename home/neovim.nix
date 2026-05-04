{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
    extraPackages = with pkgs; [
      gopls
    ];
  };

  #nvim config file
  xdg.configFile."nvim" = {
    source = ../nvim;
    recursive = true;
  };
}
