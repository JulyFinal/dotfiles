#!/bin/sh

[ "${SHELL##/*/}" != "zsh" ] && echo 'You might need to change default shell to zsh: `chsh -s /bin/zsh`'

cargo install starship

git clone https://github.com/JulyFinal/dotfiles.git
# git clone git@github.com:JulyFinal/dotfiles.git

git clone git@github.com:zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions
git clone git@github.com:zdharma-continuum/fast-syntax-highlighting $HOME/.zsh/fsh
git clone git@github.com:zsh-users/zsh-completions $HOME/.zsh/zsh-completions

cargo install starship

cd dotfiles
sh symlink-dotfiles.sh
