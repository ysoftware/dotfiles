#!/bin/sh
DIR=$(cd "$(dirname "$0")" && pwd)
UP_TO_DATE_MSG="Up to date: "

# load tmux config
TMUX_CONF_IN="$DIR/tmux.conf"
TMUX_CONF_OUT="$HOME/.tmux.conf"
if ! grep -Fsq "source-file $TMUX_CONF_IN" "$TMUX_CONF_OUT"; then
    echo "source-file $TMUX_CONF_IN  # from: $DIR/install.sh" >> "$TMUX_CONF_OUT"
    echo "'tmux: source-file $TMUX_CONF_IN' -> $TMUX_CONF_OUT"
else
    echo "${UP_TO_DATE_MSG}${TMUX_CONF_OUT}"
fi

# load nvim config
NVIM_IN="$DIR/nvim.vim"
NVIM_OUT="$HOME/.config/nvim/init.vim"
if ! grep -Fsq "so $NVIM_IN" "$NVIM_OUT"; then
    echo "so $NVIM_IN \" from $DIR/install.sh" >> "$NVIM_OUT"
    echo "'nvim: so $NVIM_IN' -> $NVIM_OUT"
else
    echo "${UP_TO_DATE_MSG}${NVIM_OUT}"
fi

# sym link nvim color scheme
COLORSCHEME_IN="$DIR/yaroscheme.vim"
COLORSCHEME_OUT="$HOME/.config/nvim/colors/yaroscheme.vim"
if [ ! -f "$COLORSCHEME_OUT" ]; then
    mkdir -p "$(dirname "$COLORSCHEME_OUT")"
    ln -sf "$COLORSCHEME_IN" "$COLORSCHEME_OUT"
    echo "$COLORSCHEME_IN -> $COLORSCHEME_OUT"
else
    echo "${UP_TO_DATE_MSG}${COLORSCHEME_OUT}"
fi

# load bash config
BASH_IN="$DIR/bashrc"
BASHPROFILE_OUT="$HOME/.bash_profile"
if ! grep -Fsq "source $BASH_IN" "$BASHPROFILE_OUT"; then
    echo "source $BASH_IN # from: $DIR/install.sh" >> "$BASHPROFILE_OUT"
    echo "'sh: source $BASH_IN' -> $BASHPROFILE_OUT"
else
    echo "${UP_TO_DATE_MSG}${BASHPROFILE_OUT}"
fi

# load bash config
BASHRC_OUT="$HOME/.bashrc"
if ! grep -Fsq "source $BASH_IN" "$BASHRC_OUT"; then
    echo "source $BASH_IN # from: $DIR/install.sh" >> "$BASHRC_OUT"
    echo "'sh: source $BASH_IN' -> $BASHRC_OUT"
else
    echo "${UP_TO_DATE_MSG}${BASHRC_OUT}"
fi
