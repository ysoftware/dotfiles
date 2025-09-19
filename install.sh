#!/bin/sh
DIR=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$HOME/.config/nvim/colors"

ln -s "$DIR/tmux.conf" "$HOME/.tmux.conf"
ln -s "$DIR/nvim.vim" "$HOME/.config/nvim/init.vim"
ln -s "$DIR/yaroscheme.vim" "$HOME/.config/nvim/colors/yaroscheme.vim"
