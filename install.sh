#!/bin/sh
DIR=$(cd "$(dirname "$0")" && pwd)
UP_TO_DATE_MSG="Up to date: "

# load tmux config
TMUX_CONF_IN="$DIR/tmux.conf"
TMUX_CONF_OUT="$HOME/.tmux.conf"
if ! grep -Fsq "source-file $TMUX_CONF_IN" "$TMUX_CONF_OUT"; then
    echo "tmux source-file $TMUX_CONF_IN  # from: $DIR/install.sh" >> "$TMUX_CONF_OUT"
    echo "'tmux source-file $TMUX_CONF_IN' -> $TMUX_CONF_OUT"
else
    echo "${UP_TO_DATE_MSG}${TMUX_CONF_OUT}"
fi

# load nvim config
NVIM_IN="$DIR/nvim.vim"
NVIM_OUT="$HOME/.config/nvim/init.vim"
if ! grep -Fsq "so $NVIM_IN" "$NVIM_OUT"; then
    echo "so $NVIM_IN \" from $DIR/install.sh" >> "$NVIM_OUT"
    echo "'so $NVIM_IN' -> $NVIM_OUT"
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
BASH_OUT="$HOME/.bash_profile"
if ! grep -Fsq "source $BASH_IN" "$BASH_OUT"; then
    echo "\nsource $BASH_IN # from: $DIR/install.sh" >> "$BASH_OUT"
    echo "'source $BASH_IN' -> $BASH_OUT"
else
    echo "${UP_TO_DATE_MSG}${BASH_OUT}"
fi
