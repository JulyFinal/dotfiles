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

 xray --config ./config.json



## WXWORK Only Wine

`sudo pacman -S wine wine-mono`

`wine ~/Downloads/WeCom_*.exe`

`wine regedit wine-breeze-dark.reg`

wine-breeze-dark.reg from `https://gist.github.com/Zeinok/ceaf6ff204792dde0ae31e0199d89398`


# app

## log

https://github.com/pamburus/hl 高性能日志阅读工具


## cmd-widget — 轻量命令速查工具

按 `Ctrl-G` 弹出 fzf 搜索常用命令，选中后直接插入当前 shell 输入框（不自动执行）。

### 为什么用 TSV

早期版本用 Markdown + rg 解析，但 ` :: ` 分隔符在某些命令中可能冲突，且 fzf 按字段拆分后列表只显示描述，命令不可见。改用 TSV（TAB 分隔）后：

- 列表同时显示描述和命令，一目了然
- TAB 是天然分隔符，不会和命令内容冲突
- 不需要 rg，awk 即可解析，依赖更轻

### 安装

在 `~/.zshrc` 中添加：

```bash
source ~/dotfiles/scripts/cmd-widget.zsh
```

默认快捷键 `Ctrl-G`。如需修改，编辑 `cmd-widget.zsh` 末尾的 `bindkey`。

### 新增命令

在 `scripts/commands/` 下新建或编辑 `.tsv` 文件，每行格式：

```
描述<TAB>命令
```

- `#` 开头的行为注释，空行被忽略
- 无 TAB 的行被跳过

示例 `scripts/commands/git.tsv`：

```
git 设置 nvim 为默认编辑器	git config --global core.editor "nvim"
git 保存凭证	git config --global credential.helper store
git pull 默认 rebase	git config --global pull.rebase true
git rebase 自动 stash	git config --global rebase.autoStash true
```

### 使用

```
Ctrl-G    → 弹出 fzf，搜索命令，选中后插入输入框
```
