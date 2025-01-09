
# final's dotfiles

## Nothing

```bash
# git config --global url."https://ghproxy.com/https://github.com".insteadOf "https://github.com"
git clone https://github.com/JulyFinal/dotfiles.git
# git clone git@github.com:JulyFinal/dotfiles.git

cd dotfiles && ./symlink-dotfiles.sh

## fonts
# mkdir -p ~/.local/share/fonts
# wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/FiraMono.zip
# unzip FiraMono.zip -d FiraMono
# mv FiraMono ~/.local/share/fonts
# fc-cache -fv
## or use paru
# paru -S otf-firamono-nerd ttf-jetbrains-mono-nerd

## install base pkg
sudo pacman -S --needed base-devel
sudo pacman -S fd ripgrep fzf sd openssl
sudo pacman -S xsel
sudo pacman -S zip unzip zlib xz
sudo pacman -S neovim lazygit proxychains-ng

sh <(curl -L https://nixos.org/nix/install) --no-daemon  # install nix

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # install rustup
# sudo pacman -S rustup
# rustup default stable

# python
curl -LsSf https://astral.sh/uv/install.sh | sh

# install paru
git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si

# tools
nix-env -iA nixpkgs.bat nixpkgs.bottom nixpkgs.tealdeer nixpkgs.zoxide nixpkgs.direnv

## lsp
nix-env -iA nixpkgs.lua-language-server nixpkgs.stylua nixpkgs.shfmt nixpkgs.taplo nixpkgs.alejandra nixpkgs.deno

cargo install --git https://github.com/estin/simple-completion-language-server.git # for helix
# cargo install harper-ls --locked # English grammar checker

uv tool install ruff
uv tool install basedpyright

# WPS
# paru -S wps-office wps-office-mui-zh-cn ttf-wps-fonts

# git
git config user.email "julyfinal@outlook.com"
git config user.name "final"
```
