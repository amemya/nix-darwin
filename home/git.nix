{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    ignores = [ ".DS_Store" ];

    signing = {
      format = "openpgp";
      key = "";
      signByDefault = true;
    };

    lfs.enable = true;

    settings = {
      user = {
        name = "";
        email = "";
      };
      init.defaultBranch = "main";
    };
  };
}
