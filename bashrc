# Reverse history
export HISTSIZE=500000
export HISTFILESIZE=500000
bind 'set completion-ignore-case on'

export BASH_SILENCE_DEPRECATION_WARNING=1 # Hide "The default interactive shell is now ..." message
export EDITOR="/opt/homebrew/bin/nvim" # For vimv
unset POSIXLY_CORRECT # a setting for grep and other tools
export HOMEBREW_NO_AUTO_UPDATE=1 # Fucking homebrew

# Jai
export PATH="$PATH:~/Documents/Other/jai/bin"
alias jai="jai-macos"

# Aliases
alias cl=clear
alias ls="ls -larth"
