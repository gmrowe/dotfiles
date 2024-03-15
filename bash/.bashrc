#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PS1 is the prompt which runs before each bash command
# See: https://wiki.archlinux.org/title/Bash/Prompt_customization#Prompts
PS1='\u@\h:\w\$ '

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias wifi='nmtui'
alias emacs='emacsclient -c -a ""'
alias open='xdg-open'
alias cat='bat'

# Added by rustup rust install
. "/home/garrett/.local/share/cargo/env"

# Add fzf keybinding scripts
# The scripts were manually copied to XDG_DATA_HOME from /usr/share/fzf/
# because I am trying to keep things clean
. "$XDG_DATA_HOME/fzf/key-bindings.bash"
. "$XDG_DATA_HOME/fzf/completion.bash"
