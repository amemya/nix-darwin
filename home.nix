{ config, pkgs, ... }:

{
  imports = [
    ./home/zsh.nix
    ./home/git.nix
    ./home/starship.nix
    ./home/neovim.nix
  ];

  home.username = "amemiya";
  home.homeDirectory = "/Users/amemiya";

  #Packages
  home.packages = with pkgs; [
    iperf3
    eza
    exiftool
    cmake
    emacs
    yt-dlp
    inetutils
    pnpm
    actionlint
    starship
    nodejs
    openjdk
    _7zz
    sl
    uv
    gauche
    go
    git
    git-lfs
    gh
    htop
    gnupg
    ffmpeg
    fastfetch
    zig
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}



