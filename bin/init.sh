#!/bin/bash

DOTFILES="$HOME/dotfiles"

export LC_ALL=en_US.UTF-8

cd $HOME

if perl -nle'exit(!/^Debian|Ubuntu/i)' /etc/issue
then
  sudo apt-get --assume-yes install git tmux
fi

if [ ! -d $DOTFILES ]
then
  git clone https://github.com/qgp9/dotfiles
fi

ln -sf $DOTFILES/.[a-z]* .

mkdir -p $HOME/.vim/backupdir
mkdir -p $HOME/.vim/swapdir

vim +PlugInstall +qa
