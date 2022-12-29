#!/bin/bash

ln -fs $PWD/.profile ~/.profile
ln -fs $PWD/.bash_profile ~/.bash_profile
ln -fs $PWD/.bashrc ~/.bashrc
ln -fs $PWD/.bash_aliases ~/.bash_aliases
ln -fs $PWD/.inputrc ~/.inputrc

mkdir -p ~/.config/git

ln -fs $PWD/.config/git/config ~/.config/git/config
ln -fs $PWD/.config/git/ignore ~/.config/git/ignore

. ./setup/brew.sh
. ./setup/apt.sh
