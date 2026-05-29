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

### 为什么用 YAML

早期版本用 Markdown + rg，后来改用 TSV。但 TSV 对人工维护不友好，TAB 不可见、多行命令不好写。YAML 解决了这些问题：

- 结构清晰，`name` / `cmd` / `tags` 一目了然
- 原生支持多行命令（`|` 块标量）
- 无需手动区分分隔符和命令内容
- IDE 和编辑器默认支持 YAML 语法高亮

### 依赖

- `fzf` — 模糊搜索
- `yq` — YAML 解析（推荐 mikefarah/yq Go 版，也兼容 kislyuk/yq Python 版）
- `base64` — 编解码多行命令

```bash
sudo pacman -S fzf yq
```

### 安装

在 `~/.zshrc` 中添加：

```bash
source ~/dotfiles/scripts/cmd-widget.zsh
```

然后 `source ~/.zshrc` 或开新终端。

默认快捷键 `Ctrl-G`。如需修改，编辑 `cmd-widget.zsh` 末尾的 `bindkey`。

如果 `Ctrl-G` 没反应，检查终端是否占用了该键：`stty -a | grep quit`。在 `~/.zshrc` 末尾加 `stty quit undef 2>/dev/null` 释放。

### 命令文件格式

放在 `scripts/commands/*.yaml`，每个文件是一个命令列表。

**单行命令：**

```yaml
- name: python 当前目录 http 服务
  cmd: uvx python -m http.server 8000
  tags: [fileserver, python]
```

**多行命令：**

```yaml
- name: git 全局配置
  cmd: |
    git config --global core.editor "nvim"
    git config --global credential.helper store
    git config --global pull.rebase true
    git config --global rebase.autoStash true
  tags: [git, init]
```

字段说明：

- `name` — 必填，命令说明，用于 fzf 搜索
- `cmd` — 必填，命令内容。多行用 `|`
- `tags` — 可选，分类标签，fzf 中显示为 `[tag1,tag2]`

### 新增命令

在 `scripts/commands/` 下新建或编辑 `.yaml` 文件，按上述格式写入即可。无需重启 shell，下次 `Ctrl-G` 自动生效。

### 使用

```
Ctrl-G    → 弹出 fzf，搜索命令，选中后插入输入框（不自动执行）
```

fzf 列表显示格式：`[tags] name :: cmd摘要`（多行命令摘要中用 `;` 连接）
