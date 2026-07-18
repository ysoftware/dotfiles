# Disable stty for non-interactive sessions; this fixes scp (copy file via ssh)
[[ $- != *i* ]] && return

# General bash settings
export BASH_SILENCE_DEPRECATION_WARNING=1 # Hide "The default interactive shell is now ..." message
unset POSIXLY_CORRECT # a setting for grep and other tools
unset command_not_found_handle # Remove automatic download suggestion of the missing command

export HOMEBREW_NO_AUTO_UPDATE=1 # Fucking homebrew
export EDITOR="nvim" # For vimv

# Reverse history
export HISTSIZE=500000
export HISTFILESIZE=500000
bind "set completion-ignore-case on"

# Jai
export PATH="$PATH:~/Documents/Other/jai/bin"

if [[ $(uname) == "Darwin" ]]; then
    alias jai="jai-macos"
else
    alias jai="jai-linux"
fi

# Aliases
alias cl=clear && printf '\e[3J' && stty sane
alias ls="LC_COLLATE=C ls -lah"
alias vim=nvim
alias se="replace -s"

# Custom apps
alias note="nvim ~/Documents/GitHub/Notes/Notes.md"
alias cal="env --chdir=$HOME/Documents/GitHub/Calcal-cli ./target/release/Calcal"
alias nob="./nob"

# Monitors set up
alias edit_monitors="nvim ~/Documents/GitHub/dotfiles/set-output.sh"
alias mond="~/Documents/GitHub/dotfiles/set-output.sh set_workspace_desk"
alias mons="~/Documents/GitHub/dotfiles/set-output.sh set_workspace_sofa"
alias mona="~/Documents/GitHub/dotfiles/set-output.sh set_workspace_all"

# jq setup
export JQ_COLORS="0;31:0;39:0;39:0;34:0;32:0;90:0;90:0;39"

# folder sizes
alias size="du -h -d 1 | sort -h -r"
alias disks="df -h"

# shut up clangd
export CLANGD_FLAGS="--clang-tidy=false"
