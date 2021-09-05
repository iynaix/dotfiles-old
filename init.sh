#! /bin/bash

set -e

stow */
ln -sf $HOME/.profile $HOME/.bash_profile
ln -sf $HOME/.profile $HOME/.zprofile
