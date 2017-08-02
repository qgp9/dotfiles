#!/bin/bash

DOTFILES="$HOME/dotfiles"

cd $HOME

ln -sf $DOTFILES/.[a-z]* .

mkdir -p $HOME/.vim/backupdir
mkdir -p $HOME/.vim/swapdir

if perl -nle'exit(!/^Debian|Ubuntu/i)' /etc/issue
then
  sudo apt-get install git tmux
fi
