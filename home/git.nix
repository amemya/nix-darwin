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
      key = "4794FBF07213A5C0ABD41F4F63863DE0E1F372AD";
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
