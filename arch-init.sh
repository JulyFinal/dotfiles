## install base pkg
sudo pacman -S --needed base-devel
sudo pacman -S fd ripgrep xsel fzf bat bottom fd lsd sd tealdeer zoxide zip unzip direnv
sudo pacman -S neovim lazygit proxychains-ng
sudo pacman -S zip unzip

git clone https://aur.archlinux.org/paru.git && cd paru &&makepkg -si
paru -S clash-for-windows-bin
# paru -S wps-office wps-office-mui-zh-cn ttf-wps-fonts
