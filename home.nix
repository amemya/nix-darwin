{ config, pkgs, lib, ... }:

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
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/amemiya" else "/home/amemiya";

  #Packages
  home.packages = with pkgs; [
    ninja
    gcc
    gnumake
    github-copilot-cli
    gomi
    tree-sitter
    iperf3
    eza
    exiftool
    cmake
    inetutils
    pnpm
    actionlint
    starship
    nodejs
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
    fastfetch
    zig
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    (julia-bin.overrideAttrs (old: { doInstallCheck = false; }))
    sqlitebrowser
    emacs
    dotnet-sdk
    openjdk
    yt-dlp
    ghostty-bin
    pinentry_mac
    ffmpeg
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    pinentry-curses
  ];

  home.file.".gnupg/gpg-agent.conf".text = if pkgs.stdenv.isDarwin then ''
    pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
  '' else ''
    pinentry-program ${pkgs.pinentry-curses}/bin/pinentry
  '';

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}



