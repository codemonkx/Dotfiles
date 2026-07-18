#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# opencode
export PATH=/home/nx02/.opencode/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"



# Added by Antigravity CLI installer
export PATH="/home/nx02/.local/bin:$PATH"
