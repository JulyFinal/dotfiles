#!/usr/bin/env bash

bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

## install base pkg
sudo pacman -S fd ripgrep xsel fzf bat bottom fd lsd sd tealdeer zoxide zip unzip

sudo pacman -S neovim lazygit proxychains-ng

sudo pacman -S zip unzip

# yay -S clash-for-windows-bin

# yay -S wps-office wps-office-mui-zh-cn ttf-wps-fonts
