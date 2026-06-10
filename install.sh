#!/bin/sh
# dotfiles を手動でシンボリックリンクする場合のスクリプト。
# (通常は mac-setting の setup.sh が自動でリンクするため任意)
#
# 前提: このリポジトリは ghq root 配下 (~/src/github.com/tomkenta/dotfiles) にある。

DOTFILES="$HOME/src/github.com/tomkenta/dotfiles"

for f in \
  .zprofile \
  .zshrc \
  .bash_profile \
  .bashrc \
  .vimrc \
  .tmux.conf \
  .gitconfig \
  .gitattributes \
  .gitignore_global; do
  ln -sf "$DOTFILES/$f" ~/"$f"
done

# ~/.config は丸ごとリンクせず、このリポジトリで管理しているサブディレクトリのみリンク
# (丸ごとリンクすると既存の他ツール設定を壊す)
# 対象: dotfiles/.config/ 配下にあるディレクトリのみ = fish, karabiner, ghostty
mkdir -p ~/.config
ln -sfn "$DOTFILES/.config/fish"      ~/.config/fish
ln -sfn "$DOTFILES/.config/karabiner" ~/.config/karabiner
ln -sfn "$DOTFILES/.config/ghostty"   ~/.config/ghostty

# Claude Code の自作スクリプト（個別ファイルのみリンク。~/.claude はツール管理ディレクトリ）
mkdir -p ~/.claude
ln -sf "$DOTFILES/.claude/statusline.sh"         ~/.claude/statusline.sh
ln -sf "$DOTFILES/.claude/statusline-command.sh" ~/.claude/statusline-command.sh
