# dotfiles

## 1. 目的

クライアントMac（MacBook Air）とサーバーMac（Mac mini）で、共通のシェル・Git・tmux・AIツールの個人設定を使える状態にする。

管理対象設定の正本をこのリポジトリに置き、ホームディレクトリへリンクまたは部分適用する。
アプリ・CLIの導入とmacOS設定は [mac-setting](https://github.com/tomkenta/mac-setting) に任せる。

## 2. 対象・対象外

| プロファイル | 適用する設定 |
|---|---|
| 共通 | zsh・bash・Vim・Git・tmux・Starship、Claudeの指示・statuslineスクリプト、Codexの指示・TUI設定 |
| クライアント（引数なし） | 共通設定＋fish・Karabiner・Ghostty・tig |
| サーバー（`--server`） | 共通設定のみ。クライアント専用の4ディレクトリは変更しない |

macOSの個人用Macを対象とする。zshのHomebrew PATH設定はApple Silicon／Intelの配置を判定するが、すべてのOSやツール構成での動作を保証するものではない。

管理しないもの:

- アプリ・CLI・プラグインのインストールや更新
- SSH・画面共有・ファイアウォールなどのmacOSサービス
- リポジトリの取得・同期
- パスワード・APIキー・Git identity・認証情報の同期
- ブラウザのログイン状態、AIツールのMCP・プラグインの一括複製

## 3. 構成

### mac-settingとの関係

```text
mac-setting
  ├─ Brewfile.common              → ツールを導入
  └─ scripts/setup-workspace.sh
       ├─ scripts/sync-repos.sh    → リポジトリを取得・更新
       └─ dotfiles/install.sh      → 設定を適用
            └─ --server           → クライアント専用設定を省く
```

`install.sh` は単独でも使える。brew・git clone・ネットワーク経由のインストールは行わない。

### 配置方法

| 配置先 | 方法・内容 |
|---|---|
| `~/.zshenv`、`~/.bash_profile`、`~/.bashrc`、`~/.vimrc` | ファイル単位のリンク |
| `~/.config/zsh/` | 実ディレクトリ内の `.zshrc`・`.zprofile` をリンク |
| `~/.config/git/` | config・attributes・ignore・hooksをリンク |
| `~/.config/tmux/` | tmux.confをリンク |
| `~/.config/starship.toml` | ファイル単位のリンク |
| `~/.config/{fish,karabiner,ghostty,tig}` | クライアントのみ、ディレクトリ単位のリンク |
| `~/.claude/` | CLAUDE.md・statusline.sh・statusline-command.shをリンク |
| `~/.codex/` | AGENTS.mdをリンク。config.tomlの `[tui]` 内のstatus_line・terminal_titleを更新 |

`~/.config` 全体はリンクしない。zsh・Git・tmuxは端末固有の設定や履歴と同居するため、管理対象だけをリンクする。
XDGの状態・データディレクトリにless・bash・Vim・tig用の保存先も作成する。

Claude/Codexのグローバル指示は、外部脳 `~/src/github.com/tomkenta/external_brain` の指示を参照する。
Codexのconfig.tomlは丸ごと置き換えず、管理対象のTUIキーだけをマージする。

## 4. 使い方

### 前提条件

- Gitとshが使えること。
- `~/.config` が実ディレクトリであること。全体がシンボリックリンクなら適用前に停止する。
- 既存の管理対象設定を確認し、必要なものをバックアップしておくこと。
- 設定が使用するツールはmac-settingで導入しておくこと。Git設定ではdelta・git-lfsを参照し、hooksはgitleaksを使う。
- 外部脳の指示を利用する場合は、external_brainも標準配置へ取得しておくこと。

### 初回セットアップ

mac-settingを使う場合は、ツール導入・GitHub認証後にそちらから呼ぶ。

```sh
cd ~/src/github.com/tomkenta/mac-setting
./scripts/setup-workspace.sh           # クライアント
# サーバーの場合は代わりに:
./scripts/setup-workspace.sh --server
```

dotfilesだけを取得・適用する場合:

```sh
mkdir -p ~/src/github.com/tomkenta
git clone https://github.com/tomkenta/dotfiles.git ~/src/github.com/tomkenta/dotfiles
cd ~/src/github.com/tomkenta/dotfiles
sh ./install.sh                       # クライアント
# サーバーの場合は代わりに:
sh ./install.sh --server
```

適用後は新しいターミナルを開く。既存のzshセッションでログイン設定も読み直すなら `exec zsh -l` を使う。

Git identityは端末ローカルで設定する。以下の値は本人の名前・メールに置き換える。

```sh
git config --file ~/.config/git/config.local user.name "YOUR_NAME"
git config --file ~/.config/git/config.local user.email "YOUR_EMAIL"
```

### 既存環境への再適用

リポジトリを更新せず、手元の設定を再適用する。

```sh
cd ~/src/github.com/tomkenta/dotfiles
sh ./install.sh                       # クライアント
# サーバーの場合は代わりに:
sh ./install.sh --server
```

サーバープロファイルに切り替えても、以前適用したクライアント専用リンクは削除されない。

### 更新

```sh
cd ~/src/github.com/tomkenta/dotfiles
git status --short
git pull --ff-only
sh ./install.sh                       # サーバーは --server を付ける
```

未コミット変更がある場合は内容を確認してから更新する。上記の直接pullには、mac-settingの同期スクリプトのような未コミット変更の事前拒否はない。
設定の一括更新・適用をしたい場合はmac-settingの `setup-workspace.sh` を使う。

リンク済みファイルはpullすると参照内容も変わる。新しいリンクやCodexのマージ設定を反映するため、更新後にinstall.shを再実行する。

### 状態確認

```sh
readlink ~/.zshenv
readlink ~/.config/zsh/.zshrc
readlink ~/.config/git/config
readlink ~/.codex/AGENTS.md
git config --get ghq.root
git var GIT_AUTHOR_IDENT
ruby tests/install_test.rb
```

リンク先がこのcheckoutを指していること、Git identityが設定済みであることを確認する。
テストは一時HOMEで設定適用を検証するもので、実端末の認証・全ツールの動作まで保証しない。

## 5. 注意事項

### 上書きするもの

- 管理対象の既存ファイルやリンクを置き換える。自動バックアップ・ロールバックはない。
- zsh・Git・tmuxのディレクトリ全体がリンクの場合、そのリンクを外して実ディレクトリを作り、管理ファイルを配置する。旧リンク先の状態ファイルは自動移行しない。
- ClaudeのCLAUDE.mdとstatuslineスクリプト、CodexのAGENTS.mdも管理対象。
- Codexの `[tui]` のstatus_line・terminal_titleは管理値に更新する。それ以外のローカル設定・MCP・認証ファイルは変更対象にしない。

### 手動認証・ローカル設定

Claude/Codex、GitHub、ブラウザなどへのログインは別途必要。install.shは認証情報をコピーしない。

端末固有の値はリポジトリ外に置く。

| 内容 | 保存先 |
|---|---|
| Git identity・認証helper | `~/.config/git/config.local` |
| シェルの秘密情報・追加設定 | `~/.config/zsh/.zshrc.local` |
| gitleaksの端末固有ルール | `~/.gitleaks.toml` |

Gitは `useConfigOnly=true` によりidentity未設定のcommitを拒否する。
認証helperの設定にはmac-settingの `scripts/setup-git-auth.sh` を使う。
`gh auth setup-git` はリンクされたGit設定を書き換え、リポジトリに変更を生む場合がある。

### 再実行時の挙動・既知の制約

- 設定の再適用を想定しているが、あらゆる既存環境での完全な冪等性は保証しない。
- クライアント専用ディレクトリやGit hooksの配置先が既存の実ディレクトリだと、リンクが内側に作られ、期待どおり置き換わらない場合がある。既存内容を退避してから適用する。
- Codex設定のマージ処理はawkによるもので、汎用TOMLパーサーではない。複雑な記法では差分を確認する。再実行時もファイルを書き直す。
- 非TTYのSSH実行では、シェル初期化時にZLE関連の警告が残る場合がある。
- テストは2回適用と既存認証・MCP設定の保持などを検証するが、端末全体の変更がゼロであることを検証するものではない。
- checkoutの移動・削除でリンクが切れる。移動後は新しい場所のinstall.shを再実行する。
