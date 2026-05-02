# amemiya's nix dotfiles (macOS & NixOS)

macOS および NixOS のシステム設定とユーザー環境を宣言的に管理するための `nix-darwin` + `nixos` + `home-manager` の設定リポジトリです。Flakes を利用して再現性の高い環境構築をクロスプラットフォームで行っています。

## 概要

- **対応OS**: macOS (`aarch64-darwin` / `x86_64-darwin`), NixOS (`x86_64-linux` / `aarch64-linux`)
- **Host**: 複数マシンのホストネーム動的取得に対応
- **ユーザー**: `amemiya`

## ディレクトリ構造

```text
.
├── flake.nix              # メインエントリーポイント（システム・HM統合、OS分岐）
├── home.nix               # Home Manager のメイン設定（OSごとのパッケージ分岐含む）
├── nixos/                 # NixOS 固有の設定
│   └── configuration.nix  # NixOS のベースシステム設定
├── modules/               # 共通・OS固有モジュール
│   ├── common.nix         # macOS / NixOS 共通の設定（zsh, フォント, 共通パッケージ）
│   └── macos-settings.nix # macOS システム設定（Dock, キーボード, Trackpad等）
├── home/                  # Home Manager 個別モジュール
│   ├── ghostty.nix        # Ghostty ターミナルの設定 (macOSのみ)
│   ├── git.nix            # Git の設定（~/.gitconfig.local 連携）
│   ├── neovim.nix         # Neovim の設定
│   ├── starship.nix       # Starship プロンプトの設定
│   ├── tex.nix            # TeX 環境の設定
│   └── zsh.nix            # Zsh の設定（nrs エイリアス定義など）
└── nvim/                  # Neovim (LazyVim) の Lua 設定
```

## 主な構成

### 共通設定 (`modules/common.nix`)
- **Zsh**: 標準シェルとしての有効化
- **Flakes**: `nix-command`, `flakes` の有効化
- **基本ツール**: `vim`, `wget` などのインストール
- **フォント**: `hackgen-nf-font` (HackGen Nerd Font) を両OSで利用

### macOS 固有設定 (`modules/macos-settings.nix`)
- **システムデフォルト**: Dock のサイズ/自動非表示、ホットコーナー、ファイアウォール等の設定。
- **ログイン画面**: ユーザー一覧表示の有効化。
- **セキュリティ**: Sudo の **TouchID 認証**を有効化。
- **キーボード/入力**: Fn キーの挙動変更、CapsLock と Control の入れ替え。
- **Trackpad**: タップでクリック、3本指ドラッグ等のジェスチャ設定。

### NixOS 固有設定 (`nixos/configuration.nix`)
- **ネットワーク・ブート**: systemd-boot, NetworkManager の有効化
- **ユーザー管理**: system-level での amemiya ユーザー定義
- ※ 実機で運用する場合は `hardware-configuration.nix` を生成して配置してください。

### ユーザー環境 (`home.nix` / `home/`)
- OS判定 (`pkgs.stdenv.isDarwin`, `pkgs.stdenv.isLinux`) を利用し、macOSでのみGUIアプリ(Ghostty)や `pinentry_mac` を導入、NixOSでは `pinentry-curses` を導入するように構成しています。
- **Zsh**: オートコンプリート、シンタックスハイライト、およびビルド用 `nrs` エイリアス（OS別挙動）。
- **Git**: `~/.gitconfig.local` が存在する場合、自動的にインクルードされます（機密情報や端末固有設定用）。
- **Neovim**: `nvim/` 配下の Lua ファイルにより詳細にカスタマイズ。

## インストール・反映手順

設定を変更した後は、ターミナルで以下のエイリアスを実行するだけで、現在のOSとホスト名を自動判定してシステムがリビルドされます。

```bash
nrs
```

内部的にはOSごとに以下のコマンドが自動的に実行されます：

**macOS の場合:**
```bash
scutil --get LocalHostName > /tmp/.nix-darwin-hostname && sudo darwin-rebuild switch --flake ~/.config/nix-darwin --impure
```

**NixOS の場合 (ローカル実行):**
```bash
hostname > /tmp/.nixos-hostname && sudo nixos-rebuild switch --flake ~/.config/nix-darwin --impure
```

**macOS から NixOS へのリモートデプロイ:**
ラズパイ等のメモリが少ないデバイス向けに、Mac側で重い評価処理を行ってからネットワーク越しにシステムを適用するコマンドを用意しています。

```bash
deploy-nixos <ユーザー名@ターゲットIP> <ホストネーム>
# 例: deploy-nixos amemiya@192.168.1.10 raspberrypi
```
※ **前提条件**: MacからターゲットへSSH公開鍵認証で接続可能であり、リモート側で sudo 実行が可能な状態である必要があります。

## 管理されている主なツール・パッケージ

### 開発・コマンドラインツール
- **言語**: Go, Zig, Node.js, OpenJDK, .NET SDK, uv (Python), Gauche
- **ツール**: CMake, Git, GitHub CLI (`gh`), GnuPG, `actionlint`
- **ユーティリティ**: `eza`, `gomi`, `fastfetch`, `htop`, `ffmpeg`, `yt-dlp`, `exiftool`, `iperf3`, `7zz`

## ライセンス・非自由ソフトウェア
`allowUnfree = true` を設定し、proprietary なパッケージも許可してインストールしています。
