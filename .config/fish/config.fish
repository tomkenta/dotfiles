# my fish config file

# alias
alias d='docker'
alias dc='docker-compose'
alias l='clear && ls -l'
alias lla='ls -la'
alias g='cd (ghq root)/(ghq list | peco)'
alias gh='hub browse (ghq list | peco | cut -d "/" -f 2,3)'
alias clip='pbcopy'
alias new_note='touch (date "+%Y%m%d").md'

set -g theme_powerline_fonts no
set -g theme_nerd_fonts yes
set -g theme_newline_cursor yes
set -g theme_newline_prompt '└->$ '
