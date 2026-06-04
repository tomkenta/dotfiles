# dotfiles

普段の Mac 環境の dotfiles。通常は [mac-setting](https://github.com/tomkenta/mac-setting)
の `setting.sh` が ansible 経由で自動取得・シンボリックリンクするため、単体での操作は不要。

## 手動でセットアップする場合

ghq で取得（`~/src` 配下に置かれる）してリンクスクリプトを実行:

```sh
ghq get tomkenta/dotfiles
cd ~/src/github.com/tomkenta/dotfiles
./install.sh
```

`install.sh` が `~/.zprofile` `.gitconfig` `.vimrc` `.tmux.conf` `.config` 等を
ホームディレクトリにシンボリックリンクする。

## 含まれる主な設定
- `.zprofile` — Apple Silicon の Homebrew (`/opt/homebrew`) に PATH を通す
- `.config/fish/config.fish` — fish のエイリアス・プロンプト・anyenv 初期化
- `.gitconfig` — git エイリアス各種、ghq root = `~/src`
- `.tmux.conf` — prefix を C-q、tpm プラグイン
- `.vimrc` / `.config/karabiner/` ほか
