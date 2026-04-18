{ config, pkgs, ... }:

{
  imports = [
    ./home/zsh.nix
    ./home/git.nix
    ./home/starship.nix
    ./home/neovim.nix
    ./home/tex.nix
    ./home/ghostty.nix
  ];

  home.username = "amemiya";
  home.homeDirectory = "/Users/amemiya";

  #Packages
  home.packages = with pkgs; [
    (julia-bin.overrideAttrs (old: { doInstallCheck = false; }))
    ghostty-bin
    ninja
    gcc
    gnumake
    github-copilot-cli
    gomi
    tree-sitter
    sqlitebrowser
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
    dotnet-sdk
    sl
    uv
    gauche
    go
    git
    git-lfs
    gh
    htop
    gnupg
    pinentry_mac
    ffmpeg
    fastfetch
    zig
  ];

  home.file.".gnupg/gpg-agent.conf".text = ''
    pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
  '';

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}



