#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias wifi='nmtui'
alias emacs='emacsclient -c -a ""'

. "/home/garrett/.local/share/cargo/env"
