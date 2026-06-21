#!/bin/sh
# dotfiles を手動でシンボリックリンクする場合のスクリプト。
# (通常は mac-setting の setup.sh が自動でリンクするため任意)
#
# 前提: このリポジトリは ghq root 配下 (~/src/github.com/tomkenta/dotfiles) にある。

DOTFILES="$HOME/src/github.com/tomkenta/dotfiles"

# home 直下に置くのは XDG 非対応ツール + zsh のブートストラップ (.zshenv) のみ。
# zsh/git/tmux 本体の設定は XDG (~/.config/) 配下へ集約している。
for f in \
  .zshenv \
  .bash_profile \
  .bashrc \
  .vimrc; do
  ln -sf "$DOTFILES/$f" ~/"$f"
done

# ~/.config は丸ごとリンクせず、このリポジトリで管理しているサブディレクトリのみリンク
# (丸ごとリンクすると既存の他ツール設定を壊す)
#
# ガード: ~/.config 自体がシンボリックリンクだと、以降の `ln -sfn` がリンク先の
# 内部に入れ子のリンクを作ってしまう (過去の wholesale-symlink 構成での事故)。
# その場合は自動で壊さず中断し、手動対応を促す。
if [ -L ~/.config ]; then
  echo "ERROR: ~/.config がシンボリックリンクです ($(readlink ~/.config))。" >&2
  echo "       実ディレクトリに変換してから再実行してください。" >&2
  exit 1
fi
mkdir -p ~/.config

# XDG 状態/データディレクトリ (less / bash / vim / tig の履歴の置き場所)。
# 各ツールは親ディレクトリを自動作成しないため、ここで用意しておく。
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
mkdir -p "$XDG_STATE_HOME/less" "$XDG_STATE_HOME/bash" \
         "$XDG_STATE_HOME/vim/swap" "$XDG_DATA_HOME/vim" "$XDG_DATA_HOME/tig"

# (a) 完全にリポジトリ管理のディレクトリ = 丸ごとリンク
ln -sfn "$DOTFILES/.config/fish"      ~/.config/fish
ln -sfn "$DOTFILES/.config/karabiner" ~/.config/karabiner
ln -sfn "$DOTFILES/.config/ghostty"   ~/.config/ghostty
ln -sfn "$DOTFILES/.config/tig"       ~/.config/tig

# (b) マシン固有/秘密/状態ファイルが同居するディレクトリ (zsh/git/tmux) は
#     「実ディレクトリ + 管理ファイルだけリンク」にして、
#     履歴・config.local・.zshrc.local 等がリポジトリ内に混入しないようにする。
#     ガード: 既存が丸ごとリンクなら実ディレクトリへ作り直す (旧構成からの移行)。
for d in zsh git tmux; do
  [ -L ~/.config/$d ] && rm ~/.config/$d
  mkdir -p ~/.config/$d
done
ln -sf "$DOTFILES/.config/zsh/.zshrc"      ~/.config/zsh/.zshrc
ln -sf "$DOTFILES/.config/zsh/.zprofile"   ~/.config/zsh/.zprofile
ln -sf "$DOTFILES/.config/tmux/tmux.conf"  ~/.config/tmux/tmux.conf
ln -sf "$DOTFILES/.config/git/config"      ~/.config/git/config
ln -sf "$DOTFILES/.config/git/attributes"  ~/.config/git/attributes
ln -sf "$DOTFILES/.config/git/ignore"      ~/.config/git/ignore
# git hooks (.gitconfig の hooksPath = ~/.config/git/hooks が参照)
ln -sfn "$DOTFILES/.config/git/hooks"      ~/.config/git/hooks

# starship は単独ファイル (~/.config/starship.toml) を読むのでファイル単位でリンク
ln -sf  "$DOTFILES/.config/starship.toml" ~/.config/starship.toml

# zsh 環境を強化するツール (未導入なら brew で導入)。
# いずれも .zshrc が存在チェックでガードしているため、未導入でも壊れない。
# (zoxide=z, fd=fzf検索, eza=ls, bat=cat, git-delta=diff, direnv=env)
if command -v brew >/dev/null 2>&1; then
  for pkg in starship zsh-autosuggestions zsh-syntax-highlighting zsh-completions \
             zoxide fd eza bat git-delta direnv; do
    brew list "$pkg" >/dev/null 2>&1 || brew install "$pkg"
  done
  # fzf は fzf-tab / `fzf --zsh` のため最新へ (旧 0.27 系だと未対応)
  if brew list fzf >/dev/null 2>&1; then brew upgrade fzf || true; else brew install fzf; fi
fi

# fzf-tab (TAB 補完の fzf 化)。brew 非提供のため git clone でマシンローカルに配置。
# 置き場所は ZDOTDIR 配下 (repo 外)。.zshrc が存在チェックで読み込む。
FZFTAB="$HOME/.config/zsh/plugins/fzf-tab"
if [ ! -d "$FZFTAB/.git" ] && command -v git >/dev/null 2>&1; then
  git clone --depth=1 https://github.com/Aloxaf/fzf-tab "$FZFTAB"
fi

# Claude Code の自作スクリプト（個別ファイルのみリンク。~/.claude はツール管理ディレクトリ）
mkdir -p ~/.claude
ln -sf "$DOTFILES/.claude/statusline.sh"         ~/.claude/statusline.sh
ln -sf "$DOTFILES/.claude/statusline-command.sh" ~/.claude/statusline-command.sh
