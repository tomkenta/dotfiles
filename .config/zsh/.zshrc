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

# ghq (絞り込みは fzf に一本化)
export GHQ_ROOT="$HOME/src"
export GHQ_EDITOR="code"

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
# ghq + fzf でリポジトリ移動
# ============================================================
# リポジトリを fzf で選択 (右ペインに README / git log をプレビュー)
_fzf_ghq_select() {
  ghq list -p | fzf --query "$1" --preview '
    d={}; if [ -f "$d/README.md" ]; then
      (command -v bat >/dev/null 2>&1 && bat --color=always --style=plain "$d/README.md") \
        || cat "$d/README.md"
    else
      git -C "$d" log --oneline --decorate --color=always -20 2>/dev/null || ls -la "$d"
    fi'
}

# C-g: その場でリポジトリを選んで cd
function fzf-ghq() {
  local dir
  dir=$(_fzf_ghq_select "$LBUFFER")
  if [ -n "$dir" ]; then
    BUFFER="cd ${dir}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N fzf-ghq
bindkey '^g' fzf-ghq

# g: コマンドとして実行してリポジトリへ cd
function fzf-ghq-cd() {
  local dir
  dir=$(_fzf_ghq_select)
  [ -n "$dir" ] && cd "$dir"
}

# ============================================================
# エイリアス
# ============================================================
alias d='docker'
alias dc='docker compose'
alias k='kubectl'
alias l='clear && ls -l'
alias clip='pbcopy'

# ---- Claude Code ----
alias c='claude'
alias cc='claude --dangerously-skip-permissions'
alias ccont='claude --continue'
alias cop='claude --model claude-opus-4-8'
alias cso='claude --model claude-sonnet-4-6'
alias cha='claude --model claude-haiku-4-5-20251001'
alias ask='claude -p'

# ---- モダン CLI (別名で追加。ls/cat/find は素のまま据え置き) ----
if command -v eza >/dev/null 2>&1; then
  alias ll='eza -l --git --icons --group-directories-first'
  alias lla='eza -la --git --icons --group-directories-first'
  alias lt='eza --tree --level=2 --icons'
else
  alias ll='ls -l'
  alias lla='ls -la'
fi
if command -v bat >/dev/null 2>&1; then
  export BAT_THEME="ansi"
  alias cat='bat'
fi

# ---- 生産性 ----
alias reload='source ${ZDOTDIR}/.zshrc'
alias md='mkdir -p'
alias myip='ipconfig getifaddr en0'
alias ports='lsof -i -P -n | grep LISTEN'
alias pn='pnpm'
alias nr='npm run'

# ---- ディレクトリ移動 (.. は AUTO_CD で効くが ... 以上はエイリアスが必要) ----
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias g='fzf-ghq-cd'   # ghq + fzf でリポジトリ選択 → cd
# 注: かつて alias gh='ghq list -p | ...' を置いていたが、GitHub CLI の `gh` を
#     潰してしまう (gh pr create 等が動かない) ため廃止。リポジトリ選択は g で足りる。
alias new_note='touch "$(date +%Y%m%d).md"'
# (履歴検索は fzf の Ctrl-R に一本化。旧 hpc エイリアスは廃止)

# ---- git (oh-my-zsh 準拠の命名。衝突回避のため status は gst 等) ----
#   ※ `git st` 形式のサブコマンド別名は .config/git/config にも別途定義あり
alias gst='git status'
alias gss='git status -s'              # 短縮表示
alias ga='git add'
alias gaa='git add -A'                 # 全変更をステージ
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gco='git checkout'
alias gcb='git checkout -b'            # ブランチ作成して切替
alias gsw='git switch'
alias gb='git branch'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate'
alias gla='git log --oneline --graph --decorate --all'
alias gp='git push'
alias gpf='git push --force-with-lease'  # 安全な強制 push
alias gpl='git pull'
alias gf='git fetch --prune'
alias gm='git merge'
alias grb='git rebase'
alias gsta='git stash'
alias gstp='git stash pop'

# ============================================================
# 関数 (旧 fish 設定から移植)
# ============================================================
# cd して中身を表示
cdh() { cd "$1" && ls -l; }
# mkdir -p してそこへ cd
mkdircd() { mkdir -p "$1" && cd "$1"; }
# gitignore テンプレートを取得: `gi macos,node > .gitignore`
gi() { curl -sL "https://www.toptal.com/developers/gitignore/api/$*"; }
# staged diff から commit メッセージを生成: gclaude
gclaude() {
  git diff --staged | claude -p \
    "Write a concise git commit message in imperative mood (subject max 50 chars). Output the message only."
}
# コマンド出力を claude に説明させる: explain <cmd> [args...]
explain() {
  "$@" | claude -p "Explain the output of: $*"
}

# ============================================================
# fzf
# ============================================================
if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border --info=inline"
  if command -v fd >/dev/null 2>&1; then
    # 検索バックエンドを fd に (.gitignore 尊重・高速・隠しファイルも対象)
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi
  command -v bat >/dev/null 2>&1 && \
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
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
# プラグイン: fzf-tab (TAB 補完を fzf メニュー化)
#   ※ compinit と fzf の後・autosuggestions/syntax-highlighting より前に読む
#   ※ マシンローカル ($ZDOTDIR/plugins/fzf-tab、repo 外。install.sh が clone)
# ============================================================
_fzftab="${ZDOTDIR:-$HOME}/plugins/fzf-tab/fzf-tab.plugin.zsh"
if [ -f "$_fzftab" ]; then
  source "$_fzftab"
  zstyle ':fzf-tab:*' fzf-flags --height=40%
  # cd 補完時はディレクトリ中身をプレビュー (eza があれば色付き)
  zstyle ':fzf-tab:complete:cd:*' fzf-preview \
    'eza -1 --color=always $realpath 2>/dev/null || ls -1 $realpath'
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
# zoxide (z: frecency cd / zi: fzf 選択) + direnv (ディレクトリ毎 env)
# ============================================================
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

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
