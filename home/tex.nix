{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (texlive.combine {
      inherit (texlive)
        scheme-small
        latexmk
        collection-langjapanese
        collection-latexextra
        collection-fontsrecommended;
    })
  ];
}
