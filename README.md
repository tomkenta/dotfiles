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
サブディレクトリ (`fish` / `karabiner` / `ghostty`) のみを個別にリンクする
（丸ごとリンクすると他ツールの既存設定を壊すため）。

秘密情報（API キー等）はリポジトリに含めない。`~/.zshrc` から `~/.zshrc.local`
（gitignore 済み）を読み込む構成のため、鍵類はそちらに置く。

## 含まれる主な設定
- `.zprofile` — Apple Silicon の Homebrew (`/opt/homebrew`) に PATH を通す
- `.config/fish/config.fish` — fish のエイリアス・プロンプト・anyenv 初期化
- `.gitconfig` — git エイリアス各種、ghq root = `~/src`
- `.tmux.conf` — prefix を C-q、ステータスバーのカスタマイズ、vim 風ペイン操作・コピーモード
- `.zshrc` — ghq + peco のリポジトリ移動、秘密情報は `~/.zshrc.local` に分離
- `.config/ghostty/config` — Ghostty ターミナルの設定
- `.vimrc` / `.config/karabiner/` ほか
