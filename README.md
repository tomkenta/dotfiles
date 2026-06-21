# dotfiles

普段の Mac 環境の dotfiles。通常は [mac-setting](https://github.com/tomkenta/mac-setting)
の `setup.sh` が ansible 経由で自動取得・シンボリックリンクするため、単体での操作は不要。

## 手動でセットアップする場合

ghq で取得（`~/src` 配下に置かれる）してリンクスクリプトを実行:

```sh
ghq get tomkenta/dotfiles
cd ~/src/github.com/tomkenta/dotfiles
./install.sh
```

`install.sh` が `~/.zprofile` `.zshrc` `.gitconfig` `.vimrc` `.tmux.conf` 等をホームディレクトリに
シンボリックリンクする。`~/.config` は丸ごとリンクせず、このリポジトリで管理する
サブディレクトリ (`fish` / `karabiner` / `ghostty`) と `starship.toml` のみを個別にリンクする
（丸ごとリンクすると他ツールの既存設定を壊すため）。あわせて zsh 強化ツール
（`starship` / `zsh-autosuggestions` / `zsh-syntax-highlighting` / `zsh-completions` / `fzf`）を
brew で導入する（未導入でも `.zshrc` が存在チェックでガードしており壊れない）。

秘密情報（API キー等）はリポジトリに含めない。`~/.zshrc` から `~/.zshrc.local`
（gitignore 済み）を読み込む構成のため、鍵類はそちらに置く。

## 含まれる主な設定
- `.zprofile` — Apple Silicon の Homebrew (`/opt/homebrew`) に PATH を通す
- `.zshrc` — メインシェル。anyenv 初期化、履歴共有/補完メニュー/各種 setopt、
  ghq + peco のリポジトリ移動 (`C-g` / `g`)、エイリアス・関数 (`cdh` / `mkdircd` / `gi` 等)、
  fzf・autosuggestions・syntax-highlighting・starship を存在チェック付きで読み込む。
  秘密情報は `~/.zshrc.local` (gitignore 済み) に分離
- `.config/starship.toml` — プロンプト。2 行表示・git ブランチ常時表示・日付/時刻・
  実行時間・exit ステータス（旧 fish テーマの再現）
- `.gitconfig` — git エイリアス各種、ghq root = `~/src`
- `.tmux.conf` — prefix を C-q、ステータスバーのカスタマイズ、vim 風ペイン操作・コピーモード
- `.config/fish/config.fish` — 旧 fish 設定（移行元・参考用に残置）
- `.config/ghostty/config` — Ghostty ターミナルの設定
- `.vimrc` / `.config/karabiner/` ほか
