#!/bin/bash

# brew へのパスを通す
source ~/.profile

brew install git gh direnv anyenv fzf

mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
