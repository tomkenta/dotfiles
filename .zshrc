# GHQ + PECO を使ったリポジトリ移動
# GHQで管理されているリポジトリをPECOで選択して移動

# GHQで管理されているリポジトリに移動する関数
function peco-ghq() {
    local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}

# GHQで管理されているリポジトリをPECOで選択して移動（cdなし）
function peco-ghq-cd() {
    local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        cd ${selected_dir}
    fi
}

# キーバインド設定
zle -N peco-ghq
bindkey '^g' peco-ghq

# エイリアス設定
alias g='peco-ghq-cd'
alias gh='ghq list -p | peco'

# GHQの設定（必要に応じて）
export GHQ_ROOT="$HOME/src"
export GHQ_EDITOR="code"

# PECOの設定
export PECO_OPTIONS="--layout=bottom-up"
export PATH="$HOME/.local/bin:$PATH"

# 秘密情報（API キー等）はリポジトリに含めず、gitignore 済みの
# ~/.zshrc.local に置いて読み込む。例: export BUFFER_API_KEY="..."
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
