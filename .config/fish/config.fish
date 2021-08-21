# my fish config file

# initialize homebrew 
/opt/homebrew/bin/brew shellenv | source

# initiall load on anyenv
anyenv init - fish | source

# alias
alias d='docker'
alias dc='docker-compose'
alias l='clear && ls -l'
alias lla='ls -la'
alias g='cd (ghq root)/(ghq list | peco)'
alias gh='hub browse (ghq list | peco | cut -d "/" -f 2,3)'
alias clip='pbcopy'
alias new_note='touch (date "+%Y%m%d").md'
alias hpc='history | peco | clip'

# envirionment value
set -gx HOMEBREW_CASK_OPTS "--appdir=~/Applications"

# PowerShell
## font
set -g theme_powerline_fonts yes

# masterでもブランチ名を表示
set -g theme_display_git_master_branch yes


# 日付を表示
set -g theme_display_date yes
set -g theme_date_format "+%F %H:%M:%S"

# コマンドの実行時間を表示
set -g theme_display_cmd_duration yes

# exitステータスを表示
set -g theme_show_exit_status yes

# shellのタイトルバー表示をカスタマイズ
set -g theme_title_display_user no
set -g theme_title_display_process yes
set -g theme_title_display_path no

##  postion for prompt
set -g theme_newline_cursor yes
set -g theme_newline_prompt '└->$ '

# no abb for directory path
set -g fish_prompt_pwd_dir_length 0

# fish function (TODO)
function cdh --description "cd and list"
   cd $argv[1] && ls -l
end
