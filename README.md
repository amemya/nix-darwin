# amemiya's nix-darwin dotfiles

macOS のシステム設定およびユーザー環境を宣言的に管理するための `nix-darwin` + `home-manager` の設定リポジトリです。Flakes を利用して再現性の高い環境構築を行っています。

## 概要

- **OS**: macOS (`aarch64-darwin`)
- **Host**: `Amemiyas-MacBook-Air`
- **ユーザー**: `amemiya`

## 主な構成

- **`flake.nix`**: システム全体の設定（`nix-darwin` の設定）、Homebrew の管理、`home-manager` の統合を行います。
- **`home.nix`**: ユーザーレベルのパッケージや、各種ツールのモジュール読み込みを行います。
- **`home/` ディレクトリ**:
  - `zsh.nix`: Zsh の設定
  - `git.nix`: Git の設定
  - `starship.nix`: Starship プロンプトの設定
  - `neovim.nix`: Neovim の設定
  - `tex.nix`: TeX 環境の設定

## インストール・反映手順

設定を変更した後は、以下のコマンドでシステムに適用（リビルド）します。

```bash
darwin-rebuild switch --flake .#Amemiyas-MacBook-Air
```

## 管理されている主なツール・パッケージ

### Homebrew (Casks / Brews)
- iTerm2
- Warp
- Scroll Reverser
- juliaup

### 開発・コマンドラインツール (Home Manager)
- **言語/ランタイム**: Go, Zig, Node.js, OpenJDK, .NET SDK, uv (Python), Gauche
- **ツール**: CMake, Git, GitHub CLI (`gh`), `git-lfs`, GnuPG
- **ユーティリティ**: `eza` (ls代替), `gomi`, `fastfetch`, `htop`, `ffmpeg`, `yt-dlp`, `exiftool`, `iperf3`, `7zz`
- **エディタ関連**: Neovim, Emacs, `github-copilot-cli`, `actionlint`

### フォント
- `hackgen-nf-font` (HackGen Nerd Font)

## ライセンス・非自由ソフトウェア
`allowUnfree = true` を設定し、`github-copilot-cli` などの proprietary なパッケージも許可してインストールしています。
