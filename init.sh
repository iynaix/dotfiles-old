#! /bin/bash

set -e

ln -sf . $HOME/.dotfiles
cd $HOME/.dotfiles

stow */
ln -sf $HOME/.profile $HOME/.bash_profile
ln -sf $HOME/.profile $HOME/.zprofile
