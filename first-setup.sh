#!/usr/bin/env bash

git clone git@github.com:zsh-users/zsh-autosuggestions $HOME/.zsh/zsh-autosuggestions
git clone git@github.com:zdharma-continuum/fast-syntax-highlighting $HOME/.zsh/fsh
git clone git@github.com:zsh-users/zsh-completions $HOME/.zsh/zsh-completions

cargo install starship

## install base pkg
sudo pacman -S fd ripgrep xsel fzf bat bottom fd lsd sd tealdeer zoxide zip unzip direnv

sudo pacman -S neovim lazygit proxychains-ng

sudo pacman -S zip unzip

# yay -S clash-for-windows-bin

# yay -S wps-office wps-office-mui-zh-cn ttf-wps-fonts
