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

# symlink palette (on GNOME)
PALETTE_IN="$DIR/ptyxis.palette"
PALETTE_DIR="$HOME/.local/share/org.gnome.Ptyxis/palettes"
PALETTE_OUT="$PALETTE_DIR/yaroscheme.palette"

if [ -d "$HOME/.local/share/org.gnome.Ptyxis" ]; then
    mkdir -p "$PALETTE_DIR"
    if [ ! -f "$PALETTE_OUT" ]; then
        ln -sf "$PALETTE_IN" "$PALETTE_OUT"
        echo "$PALETTE_IN -> $PALETTE_OUT"
    else
        echo "${UP_TO_DATE_MSG}${PALETTE_OUT}"
    fi
fi

# sym link git pre-commit hook
PRECOMMIT_IN="$DIR/git-precommit-no-checkin.sh"
PRECOMMIT_OUT="$HOME/.githooks/pre-commit"

if [ ! -L "$PRECOMMIT_OUT" ] || [ "$(readlink "$PRECOMMIT_OUT")" != "$PRECOMMIT_IN" ]; then # TODO: this might be the better way to update symlinks, look into it
    mkdir -p "$(dirname "$PRECOMMIT_OUT")"
    ln -sf "$PRECOMMIT_IN" "$PRECOMMIT_OUT"
    chmod +x "$PRECOMMIT_IN"
    echo "$PRECOMMIT_IN -> $PRECOMMIT_OUT"
    git config --global core.hooksPath ~/.githooks
else
    chmod +x "$PRECOMMIT_IN"
    echo "${UP_TO_DATE_MSG}${PRECOMMIT_OUT}"
fi

