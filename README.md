# final's dotfiles

## fist step

```bash
# git config --global url."https://ghproxy.com/https://github.com".insteadOf "https://github.com"
git clone https://github.com/JulyFinal/dotfiles.git
# git clone git@github.com:JulyFinal/dotfiles.git
cd dotfiles && ./symlink-dotfiles.sh
```


## install base pkg

`sudo pacman -S --needed base-devel # for pacman`

`fd ripgrep fzf sd openssl xsel zip unzip zlib xz neovim lazygit starship bat bottom tealdeer zoxide direnv atuin`

## zsh

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
```


## nix

```
sh <(curl -L https://nixos.org/nix/install) --no-daemon

nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable nixpkgs
nix-channel --update
```


## rust
`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh` # install rustup

`# rustup default stable`

## python
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh

uv tool install ruff
uv tool install basedpyright
```

## tools
`nix-env -iA nixpkgs.`

## lsp
```bash
lua-language-server StyLua shfmt taplo alejandra deno
cargo install --git https://github.com/estin/simple-completion-language-server.git # for helix
# cargo install harper-ls --locked # English grammar checker
```


## git

```bash
git config user.email "julyfinal@outlook.com"
git config user.name "final"
```


## WIP hyprland

`hyprland waybar kitty`


pavucontrol -> pulsemixer

nm-connection-editor -> nmcli nmtui

wofi

swaync

automount udisk

`pacman -S udiskie`

https://wiki.archlinuxcn.org/wiki/Hyprland

https://blog.manjusaka.de/p/0-0-0-52/#%E5%AE%89%E8%A3%85snapper



## VPN

`networkmanager-openvpn`

`nmcli connection import type openvpn file xxx.ovpn`


## PROXY

sudo pacman -S v2raya xray

sudo systemctl enable --now v2raya  # 启动并配置开机自启

sudo vim /etc/default/v2raya

V2RAYA_V2RAY_BIN=/usr/bin/xray

V2RAYA_V2RAY_ASSETSDIR=/usr/share/xray

sudo systemctl restart v2raya


/etc/systemd/system/v2raya.service.d

[Service]
Environment="V2RAYA_V2RAY_BIN=/usr/bin/xray"
Environment="V2RAYA_V2RAY_ASSETSDIR=/usr/share/xray"

sudo systemctl daemon-reload && sudo systemctl restart v2raya



sudo pacman -S fcitx5-im fcitx5-chinese-addons fcitx5-anthy fcitx5-pinyin-moegirl fcitx5-material-color fcitx5-pinyin-zhwiki



## WXWORK Only Wine

`sudo pacman -S wine wine-mono`

`wine ~/Downloads/WeCom_*.exe`

`wine regedit wine-breeze-dark.reg`

wine-breeze-dark.reg from `https://gist.github.com/Zeinok/ceaf6ff204792dde0ae31e0199d89398`
