# Midnight Obsidian Zsh Configuration

# Enable colors and change prompt
autoload -U colors && colors
export TERM="xterm-256color"

# History setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# Basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Aliases
alias ls="ls --color=auto"
alias ll="ls -la --color=auto"
alias grep="grep --color=auto"
alias update="yay -Syu"
alias c="clear"
alias q="exit"

# Initialize Starship prompt
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# Enable Zsh plugins (autosuggestions first, syntax-highlighting last)
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi


# Added by Antigravity CLI installer
export PATH="/home/nx02/.local/bin:$PATH"
