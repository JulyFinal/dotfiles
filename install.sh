#!/bin/sh

[ "${SHELL##/*/}" != "zsh" ] && echo 'You might need to change default shell to zsh: `chsh -s /bin/zsh`'

sh <(curl -L https://nixos.org/nix/install) --no-daemon

cargo install starship

git clone https://github.com/JulyFinal/dotfiles.git
# git clone git@github.com:JulyFinal/dotfiles.git

cargo install starship

cd dotfiles
sh symlink-dotfiles.sh
