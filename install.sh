#!/bin/sh

[ "${SHELL##/*/}" != "zsh" ] && echo 'You might need to change default shell to zsh: `chsh -s /bin/zsh`'

sh <(curl -L https://nixos.org/nix/install) --no-daemon

# git config --global url."https://ghproxy.com/https://github.com".insteadOf "https://github.com"
git clone https://github.com/JulyFinal/dotfiles.git
# git clone git@github.com:JulyFinal/dotfiles.git

cd dotfiles
git submodule update --init --recursive
sh symlink-dotfiles.sh

## fonts
# wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/FiraMono.zip
# unzip FiraMono.zip -d FiraMono
# mv FiraMono /usr/share/fonts/
# fc-cache -fv
