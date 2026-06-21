# ~/.zshenv — zsh が最初に必ず読む唯一のファイル (home 直下)。
# ここでは ZDOTDIR を指すだけにとどめ、本体の設定は ~/.config/zsh/ 配下に置く。
# これにより home 直下から .zshrc / .zprofile を排除して XDG 準拠で整理する。
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
