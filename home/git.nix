{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    includes = [
      { path = "~/.gitconfig.local"; }
    ];
    ignores = [ ".DS_Store" ];

    signing = {
      format = "openpgp";
      signByDefault = true;
    };

    lfs.enable = true;

    settings = {
      user = {
        name = "amemya";
        email = "me@amemiya.blog";
      };
      init.defaultBranch = "main";
      gpg.program = "${pkgs.gnupg}/bin/gpg";
    };
  };
}
