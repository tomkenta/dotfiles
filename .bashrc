# XDG: home 直下に履歴を置かない (zsh が主だが bash でも揃える)
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
mkdir -p "$XDG_STATE_HOME/bash" "$XDG_STATE_HOME/less"
export HISTFILE="$XDG_STATE_HOME/bash/history"   # ~/.bash_history → state/bash/history
export LESSHISTFILE="$XDG_STATE_HOME/less/history" # ~/.lesshst → state/less/history

# ALIAS
alias ll='ls -l'
alias clip='pbcopy'
alias clipp='pbpaste'
