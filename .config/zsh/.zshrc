# ~/.zshrc — interactive zsh configuration
#
# 構成方針:
#   - 追加ツール (starship / zsh-autosuggestions / zsh-syntax-highlighting /
#     zsh-completions / fzf) は brew で導入。未導入でも壊れないよう存在チェックで
#     ガードしている。導入は install.sh が行う。
#   - 秘密情報 (API キー等) はリポジトリに含めず、gitignore 済みの
#     ~/.zshrc.local に置いて最終行で読み込む。
#
# 旧 fish 設定 (.config/fish/config.fish) からの移植元のため、エイリアス・関数・
# プロンプト項目は概ね対応している。

# ============================================================
# PATH / 環境変数
# ============================================================
export PATH="$HOME/.local/bin:$PATH"
export LANG="en_US.UTF-8"
export EDITOR="vim"

# Homebrew Cask のインストール先 (旧 fish 設定から移植)
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# ghq / peco
export GHQ_ROOT="$HOME/src"
export GHQ_EDITOR="code"
export PECO_OPTIONS="--layout=bottom-up"

# ============================================================
# anyenv (rbenv / pyenv / nodenv 等)
# ============================================================
if command -v anyenv >/dev/null 2>&1; then
  eval "$(anyenv init - zsh)"
fi

# ============================================================
# 履歴
# ============================================================
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY         # 複数セッション間で履歴を共有
setopt EXTENDED_HISTORY      # タイムスタンプ付きで保存
setopt HIST_IGNORE_ALL_DUPS  # 重複コマンドは古い方を捨てる
setopt HIST_IGNORE_SPACE     # 先頭スペース付きコマンドは記録しない
setopt HIST_REDUCE_BLANKS    # 余分な空白を削って記録
setopt HIST_VERIFY           # 履歴展開 (!! 等) は即実行せず一度行に展開

# ============================================================
# シェル挙動 (setopt)
# ============================================================
setopt AUTO_CD               # ディレクトリ名だけで cd
setopt AUTO_PUSHD            # cd 時に自動で pushd (`cd -<TAB>` で履歴移動)
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt NO_BEEP
setopt INTERACTIVE_COMMENTS  # 対話シェルでも # コメントを許可
setopt NO_FLOW_CONTROL       # C-s / C-q を端末フロー制御から解放
setopt COMPLETE_IN_WORD      # カーソル位置から補完
setopt ALWAYS_TO_END
setopt EXTENDED_GLOB

# ============================================================
# 補完システム (compinit)
# ============================================================
# brew の zsh-completions を fpath に追加 (導入済みのときのみ)
if command -v brew >/dev/null 2>&1; then
  _brew_prefix="$(brew --prefix)"
  if [ -d "$_brew_prefix/share/zsh-completions" ]; then
    fpath=("$_brew_prefix/share/zsh-completions" $fpath)
  fi
fi

autoload -Uz compinit
# .zcompdump は ZDOTDIR 配下に置く (home 直下を汚さない)
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
# 24h より新しければ再構築をスキップして起動を高速化
if [[ -n "$_zcompdump"(#qN.mh+24) ]]; then
  compinit -d "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi

zstyle ':completion:*' menu select                          # 補完候補をメニュー選択
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # 大文字小文字を区別しない
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"     # 候補に色付け
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"

# ============================================================
# キーバインド
# ============================================================
bindkey -e   # emacs キーバインド

# 入力済み文字列で前方一致する履歴検索 (↑↓ / C-p C-n)
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end
bindkey '^P'   history-beginning-search-backward-end
bindkey '^N'   history-beginning-search-forward-end

# ============================================================
# ghq + peco でリポジトリ移動
# ============================================================
# C-g: 入力行を peco に渡してリポジトリを選び、その場で cd
function peco-ghq() {
  local selected_dir
  selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-ghq
bindkey '^g' peco-ghq

# g: コマンドとして実行してリポジトリへ cd
function peco-ghq-cd() {
  local selected_dir
  selected_dir=$(ghq list -p | peco)
  if [ -n "$selected_dir" ]; then
    cd "${selected_dir}"
  fi
}

# ============================================================
# エイリアス
# ============================================================
alias d='docker'
alias dc='docker compose'
alias k='kubectl'
alias l='clear && ls -l'
alias ll='ls -l'
alias lla='ls -la'
alias clip='pbcopy'
alias g='peco-ghq-cd'   # ghq + peco でリポジトリ選択 → cd
# 注: かつて alias gh='ghq list -p | peco' を置いていたが、GitHub CLI の `gh` を
#     潰してしまう (gh pr create 等が動かない) ため廃止。リポジトリ選択は g で足りる。
alias new_note='touch "$(date +%Y%m%d).md"'
# 履歴を peco で選んでクリップボードへ
alias hpc='print -rl -- "${(@k)history}" | tac | peco | clip'

# ============================================================
# 関数 (旧 fish 設定から移植)
# ============================================================
# cd して中身を表示
cdh() { cd "$1" && ls -l; }
# mkdir -p してそこへ cd
mkdircd() { mkdir -p "$1" && cd "$1"; }
# gitignore テンプレートを取得: `gi macos,node > .gitignore`
gi() { curl -sL "https://www.toptal.com/developers/gitignore/api/$*"; }

# ============================================================
# fzf
# ============================================================
if command -v fzf >/dev/null 2>&1; then
  if fzf --zsh >/dev/null 2>&1; then
    # fzf >= 0.48: キーバインド/補完を一括ロード
    source <(fzf --zsh)
  elif command -v brew >/dev/null 2>&1; then
    # 旧バージョン: brew が配置する shell スクリプトを個別に読み込む
    _fzf_shell="$(brew --prefix)/opt/fzf/shell"
    [ -f "$_fzf_shell/completion.zsh" ]   && source "$_fzf_shell/completion.zsh"
    [ -f "$_fzf_shell/key-bindings.zsh" ] && source "$_fzf_shell/key-bindings.zsh"
  fi
fi

# ============================================================
# プラグイン: autosuggestions (履歴からグレーで先読み補完)
# ============================================================
if command -v brew >/dev/null 2>&1; then
  _autosuggest="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [ -f "$_autosuggest" ] && source "$_autosuggest"
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# ============================================================
# プロンプト: starship
# ============================================================
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# ============================================================
# プラグイン: syntax-highlighting
#   ※ ZLE ウィジェットを包むため、必ず他のプラグイン/バインドの後＝末尾で読む
# ============================================================
if command -v brew >/dev/null 2>&1; then
  _highlight="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [ -f "$_highlight" ] && source "$_highlight"
fi

# ============================================================
# 秘密情報 (ローカル専用・gitignore 済み)
#   ZDOTDIR 配下 (~/.config/zsh/.zshrc.local) を読む
# ============================================================
[ -f "${ZDOTDIR:-$HOME}/.zshrc.local" ] && source "${ZDOTDIR:-$HOME}/.zshrc.local"
