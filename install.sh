#!/bin/sh

sh <(curl -L https://nixos.org/nix/install) --no-daemon  # install nix
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # install rustup
# rustup default stable

# bash ble
nix-env -iA nixpkgs.blesh

# uv
cargo install --git https://github.com/astral-sh/uv uv # or use brew: brew install uv

# git config --global url."https://ghproxy.com/https://github.com".insteadOf "https://github.com"
git clone https://github.com/JulyFinal/dotfiles.git
# git clone git@github.com:JulyFinal/dotfiles.git

cd dotfiles
sh symlink-dotfiles.sh

## fonts
# mkdir -p ~/.local/share/fonts
# wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/FiraMono.zip
# unzip FiraMono.zip -d FiraMono
# mv FiraMono ~/.local/share/fonts
# fc-cache -fv
## or use paru
# paru -S otf-firamono-nerd ttf-jetbrains-mono-nerd
