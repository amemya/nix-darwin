# amemiya's nix-darwin dotfiles

macOS のシステム設定およびユーザー環境を宣言的に管理するための `nix-darwin` + `home-manager` の設定リポジトリです。Flakes を利用して再現性の高い環境構築を行っています。

## 概要

- **OS**: macOS (`aarch64-darwin`)
- **Host**: `Amemiyas-MacBook-Air` (動的取得に対応)
- **ユーザー**: `amemiya`

## ディレクトリ構造

```text
.
├── flake.nix              # メインエントリーポイント（システム・HM統合）
├── home.nix               # Home Manager のメイン設定
├── modules/
│   └── macos-settings.nix # macOS システム設定（Dock, キーボード, Trackpad等）
├── home/                  # Home Manager 個別モジュール
│   ├── ghostty.nix        # Ghostty ターミナルの設定
│   ├── git.nix            # Git の設定（~/.gitconfig.local 連携）
│   ├── neovim.nix         # Neovim の設定
│   ├── starship.nix       # Starship プロンプトの設定
│   ├── tex.nix            # TeX 環境の設定
│   └── zsh.nix            # Zsh の設定（nrs エイリアス定義）
└── nvim/                  # Neovim (LazyVim) の Lua 設定
```

## 主な構成

### システム設定 (`modules/macos-settings.nix`)
- **システムデフォルト**: Dock のサイズ/自動非表示、ホットコーナー、ファイアウォール等の設定。
- **ログイン画面**: ユーザー一覧表示の有効化。
- **セキュリティ**: Sudo の **TouchID 認証**を有効化。
- **キーボード/入力**: Fn キーの挙動変更、CapsLock と Control の入れ替え。
- **Trackpad**: タップでクリック、3本指ドラッグ等のジェスチャ設定。

### ユーザー環境 (`home/`)
- **Zsh**: オートコンプリート、シンタックスハイライト、および `nrs` コマンドの定義。
- **Git**: `~/.gitconfig.local` が存在する場合、自動的にインクルードされます（機密情報や端末固有設定用）。
- **Ghostty**: モダンな GPU 加速ターミナルの設定。
- **Neovim**: `nvim/` 配下の Lua ファイルにより詳細にカスタマイズ。

## インストール・反映手順

設定を変更した後は、以下のエイリアスを使用してシステムに適用（リビルド）します。

```bash
nrs
```

内部的には以下のコマンドを実行してホスト名を動的に取得し、リビルドを行っています。

```bash
scutil --get LocalHostName > /tmp/.nix-darwin-hostname && sudo darwin-rebuild switch --flake ~/.config/nix-darwin --impure
```

## 管理されている主なツール・パッケージ

### 開発・コマンドラインツール
- **言語**: Go, Zig, Node.js, OpenJDK, .NET SDK, uv (Python), Gauche
- **ツール**: CMake, Git, GitHub CLI (`gh`), GnuPG, `actionlint`
- **ユーティリティ**: `eza`, `gomi`, `fastfetch`, `htop`, `ffmpeg`, `yt-dlp`, `exiftool`, `iperf3`, `7zz`

### フォント
- `hackgen-nf-font` (HackGen Nerd Font)

## ライセンス・非自由ソフトウェア
`allowUnfree = true` を設定し、proprietary なパッケージも許可してインストールしています。

