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

`install.sh` がホーム直下には XDG 非対応ツールの設定 (`~/.bashrc` `.bash_profile` `.vimrc`) と
zsh ブートストラップ (`~/.zshenv`) のみをリンクする。zsh / git / tmux の本体設定は
**XDG Base Directory** に準拠して `~/.config/` 配下へ集約している（ホーム直下を散らかさない方針）。
`~/.config` は丸ごとリンクせず、完全管理ディレクトリ (`fish` / `karabiner` / `ghostty`) は
丸ごと、マシン固有/秘密/状態ファイルが同居する `zsh` / `git` / `tmux` は「実ディレクトリ＋
管理ファイルのみリンク」でセットアップする（履歴や `config.local` 等がリポジトリに混入しないため）。
あわせて zsh 強化ツール（`starship` / `zsh-autosuggestions` / `zsh-syntax-highlighting` /
`zsh-completions` / `fzf`）を brew で導入する（未導入でも `.zshrc` がガードしており壊れない）。

秘密情報（API キー等）はリポジトリに含めない。`.zshrc` から `~/.config/zsh/.zshrc.local`
（gitignore 済み）を読み込む構成のため、鍵類はそちらに置く。

## XDG 構成（ホーム直下を整理）
- `~/.zshenv` — home 直下で zsh が最初に読む唯一のファイル。`ZDOTDIR=~/.config/zsh` を指すだけ
- `~/.config/zsh/.zshrc` `.zprofile` — zsh 本体。履歴 (`.zsh_history`)・補完キャッシュ (`.zcompdump`)・
  秘密 (`.zshrc.local`) も同ディレクトリ内に集約
- `~/.config/git/{config,attributes,ignore,hooks}` — git はネイティブで XDG を参照。
  identity 等マシン固有設定は `config.local`（非追跡）に分離
- `~/.config/tmux/tmux.conf` — tmux はネイティブで XDG を参照

## 含まれる主な設定
- `.config/zsh/.zprofile` — Apple Silicon の Homebrew (`/opt/homebrew`) に PATH を通す
- `.config/zsh/.zshrc` — メインシェル。anyenv 初期化、履歴共有/補完メニュー/各種 setopt、
  ghq + fzf のリポジトリ移動 (`C-g` / `g`、プレビュー付)、エイリアス・関数 (`cdh` / `mkdircd` / `gi` 等)、
  以下のツールを存在チェック付きで読み込む（未導入でも壊れない）:
  starship / zsh-autosuggestions / zsh-syntax-highlighting / fzf / fzf-tab /
  **zoxide** (`z`/`zi`) / **direnv** / モダン CLI (`eza`→`ll`/`lla`/`lt`, `bat`, `fd`)
- `.config/starship.toml` — プロンプト。パス短縮＋ブランチ＋`❯` のミニマル1行
- `.config/git/config` — git エイリアス各種、ghq root = `~/src`、identity は焼き付き防止、
  diff ページャに **delta**（行番号・色付き）
- `.config/tmux/tmux.conf` — prefix を C-q、ステータスバー、vim 風ペイン操作・コピーモード
- `.config/fish/config.fish` — 旧 fish 設定（移行元・参考用に残置）
- `.config/ghostty/config` — Ghostty ターミナルの設定
- `.vimrc` / `.config/karabiner/` ほか
