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
    (julia-bin.overrideAttrs (old: { doInstallCheck = false; }))
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
    ffmpeg
    fastfetch
    zig
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    ghostty-bin
    pinentry_mac
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



