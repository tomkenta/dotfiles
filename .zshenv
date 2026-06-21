# ~/.zshenv — zsh が最初に必ず読む唯一のファイル (home 直下)。
# ここでは XDG ベースディレクトリと ZDOTDIR を定義するだけにとどめ、
# 本体の設定は ~/.config/zsh/ 配下に置く。
# これにより home 直下から .zshrc / .zprofile を排除して XDG 準拠で整理する。

# ============================================================
# XDG Base Directory (明示的に定義し、以降のツール設定から参照する)
# ============================================================
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# zsh 本体設定の置き場所
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# ============================================================
# XDG 非対応だが環境変数で移動できるツールの状態ファイルを追い出す
#   (置き場所のディレクトリは install.sh が作成する)
# ============================================================
# less の検索履歴 (~/.lesshst → state)
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
