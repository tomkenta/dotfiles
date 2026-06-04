#!/bin/sh
# dotfiles を手動でシンボリックリンクする場合のスクリプト。
# (通常は mac-setting の ansible (dotfiles role) が自動でリンクするため任意)
#
# 前提: このリポジトリは ghq root 配下 (~/src/github.com/tomkenta/dotfiles) にある。

DOTFILES="$HOME/src/github.com/tomkenta/dotfiles"

ln -sf "$DOTFILES/.zprofile"          ~/.zprofile
ln -sf "$DOTFILES/.bash_profile"      ~/.bash_profile
ln -sf "$DOTFILES/.bashrc"            ~/.bashrc
ln -sf "$DOTFILES/.vimrc"             ~/.vimrc
ln -sf "$DOTFILES/.tmux.conf"         ~/.tmux.conf
ln -sf "$DOTFILES/.gitconfig"         ~/.gitconfig
ln -sf "$DOTFILES/.gitattributes"     ~/.gitattributes
ln -sf "$DOTFILES/.gitignore_global"  ~/.gitignore_global
ln -sf "$DOTFILES/.config"            ~/.config
