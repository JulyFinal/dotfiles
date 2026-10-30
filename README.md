# Dotfiles

`home/` 就是家目录的复刻。去掉 `home/`，就是文件在 `~` 下的位置。

```text
home/
├── .bashrc
├── .profile
├── .zshrc
├── .tmux.conf
├── .config/
│   ├── mise/
│   ├── nvim/
│   ├── shell/
│   ├── kitty/
│   └── …
├── .local/share/navi/
└── .pi/agent/
setup
```

## 初始化 / 更新

```sh
git clone https://github.com/JulyFinal/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup
```

`setup` 按相同路径逐个建立文件软链接，**覆盖目标处已有的文件或软链接，不备份**。
其他文件保留；遇到同名目录或父目录软链接会报错，由你手动整理后重跑。
脚本不下载、不安装软件，也不会自动拉取 Git 更新。

`.bashrc`、`.profile`、`.zshrc` 是例外：保留本机内容，只补上仓库入口中的加载语句，
已有的相同语句不会重复添加。实际 Shell 配置编辑 `home/.config/shell/`。
这些入口只放单行加载语句；仅本机使用的内容可以继续写在 `~/.zshrc` 等入口，
也可以写进 `~/.zshrc.local`、`~/.bashrc.local`、`~/.profile.local`。

平时直接编辑 `home/` 中的配置，或编辑已经链接的目标文件。
保存后文件内容立即同步，应用按自身方式重载配置。新增文件后再运行一次 `./setup`。
更新仓库后也运行同一个命令：

```sh
git pull
./setup
```

旧机器上的链接若指向已移除的 `config/` 文件，重跑 `setup` 会重新建立。
仓库中删除的文件不会自动从机器上清理；移动仓库后需要重新运行 `setup`。

Pi 的两个 JSON 文件也是普通配置，直接链接并覆盖，不再做模板渲染或字段合并。
需要保留本机 Pi 设置时，先手动整理差异。软链接目标中的修改也会写回仓库，密钥、
令牌和机器私有配置不要放进这些文件；提交前可运行 `./tests/pre-commit worktree`。

## 软件安装

配置和安装分开，按需执行：

```sh
./scripts/install-mise
export PATH="$HOME/.local/bin:$PATH"
mise trust ~/.config/mise/config.toml
mise install

# Yazi 插件与主题
ya pkg install

# Agent skills（来源在 manifests/agent-skills.yaml）
mise run skills-sync
```

Arch 系统安装脚本保留在 `systems/arch/install`；Linux / macOS 软件列表在 `systems/`。
更多 Mise 命令见 [recipes/mise.md](recipes/mise.md)。

## 检查

```sh
./tests/smoke.sh
./tests/pre-commit worktree
```

冒烟测试使用临时 HOME，不修改当前用户配置。需要提交时自动检查敏感信息，可手动启用：

```sh
git config core.hooksPath tests
```
