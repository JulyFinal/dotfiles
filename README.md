# Dotfiles

仓库内的配置文件和目录不以 `.` 开头，直接可见。`setup` 安装时给第一层名称补上点：

| 仓库文件 | 本机路径 |
| --- | --- |
| `home/zshrc` | `~/.config/shell/zshrc`，由 `~/.zshrc` 加载 |
| `home/bashrc`、`home/profile` | `~/.config/shell/bashrc`、`profile`，由对应入口加载 |
| `home/config/` | `~/.config/` |
| `home/tmux.conf` | `~/.tmux.conf` |
| `home/local/` | `~/.local/` |
| `home/pi/` | `~/.pi/` |

常用编辑位置：

- **zsh 配置**：`home/zshrc`
- **别名和代理（`eproxy`、`unproxy`）**：`home/config/shell/aliases.sh`
- **共享环境变量和 PATH**：`home/config/shell/common.sh`
- **各软件配置**：`home/config/<软件名>/`

仓库其余内容：`scripts/` 放辅助脚本，`systems/` 放系统软件清单和 Arch 安装脚本，
`tests/` 做验证，`skills.yaml` 列出 AI 技能来源，`AGENTS.md` 给编程助手说明仓库规则。

## 日常使用

```sh
eproxy                         # 开启默认代理（10808）
nproxy                         # 订阅节点代理，10809 自动选节点
dproxy                         # DNS 直连代理，10818 全部直连
eproxy http://127.0.0.1:7890    # 临时换地址；下次不带参数仍使用默认值
checkproxy                     # 查看代理状态
unproxy                        # 关闭代理
zshreload                      # 编辑后重载配置
```

代理默认地址只需在 `home/config/shell/aliases.sh` 的 `eproxy` 函数中改一处。
navi 中的代理条目也调用这些命令。重复重载共享配置不会重复添加 PATH。

`nproxy` 或 `dproxy` 启动后照常运行 `mise up`、`mise install` 等命令。
`unproxy` 关闭，`eproxy` 切回原来的 `10808`；两种新代理之间也可直接切换。
仅影响当前 shell 及其子进程；多个 shell 共用对应的独立实例，最后一个使用者
关闭代理或退出后自动停止，不改动已有 mihomo 服务。

| 命令 | 本机端口 | 用途 | 仓库配置 |
| --- | --- | --- | --- |
| `eproxy` | `10808` | 原有代理 | 保持原样 |
| `nproxy` | `10809` | 订阅节点，自动测延迟选择 | `home/config/nproxy/config.yaml` |
| `dproxy` | `10818` | 全部 DIRECT，境外 DNS 优先 | `home/config/dproxy/config.yaml` |

`nproxy` 启动时测试候选节点并选择已测最快的可用节点。
`nproxy` 先按本机的境外优先 DNS 配置解析目标，再经订阅节点发送 IP，
减少远端 DNS 不稳定的影响；至少一个节点实测通过后才切换当前终端代理。

两个独立实例仅监听 `127.0.0.1`，主解析使用本机实测更适合 GitHub 的 NextDNS TCP DNS；
解析失败时以 Google TCP DNS 兜底，当前不配置国内 DNS。
关闭 GeoIP 回退判断，避免正常的境外地址被替换。需要已安装 `mihomo` 和 Python 3，`nproxy` 还需要 `yq` 和 `curl`。
日志分别在 `~/.local/state/nproxy/mihomo.log`、`~/.local/state/dproxy/mihomo.log`。

订阅地址只存本机 `~/.config/nproxy/subscription.url`（权限 `600`），不要提交到仓库。
`nproxy` 启动时按需更新订阅，缓存一小时；更新失败时可继续使用已有缓存。
节点凭据保存在 `~/.local/state/nproxy/data/`，订阅中的其他端口、规则和 DNS 配置不会应用。

## 初始化 / 更新

```sh
git clone https://github.com/JulyFinal/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup
```

`setup` 按上述映射逐个建立文件软链接，**覆盖目标处已有的文件或软链接，不备份**。
其他文件保留；遇到同名目录或父目录软链接会报错，由你手动整理后重跑。
脚本不下载、不安装软件，也不会自动拉取 Git 更新。

`.bashrc`、`.profile`、`.zshrc` 是例外：保留本机内容，只补上加载语句，已有的相同语句不会重复添加。
实际 Shell 配置编辑 `home/zshrc`、`home/bashrc`、`home/profile`；
它们链接到 `~/.config/shell/`，与可被其他工具改写的本机入口隔开。
仅本机使用的内容可以继续写在 `~/.zshrc` 等入口，
也可以写进 `~/.zshrc.local`、`~/.bashrc.local`、`~/.profile.local`。

平时直接编辑 `home/` 中的配置，或编辑已经链接的目标文件。
保存后文件内容立即同步，应用按自身方式重载配置。新增文件后再运行一次 `./setup`。
更新仓库后也运行同一个命令：

```sh
git pull
./setup
```

从旧版含点文件名的仓库结构更新后，运行 `setup` 即可修复软链接。
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

# Agent skills（来源与目标在 skills.yaml）
mise run skills-sync -- --dry-run  # 预览
mise run skills-sync
```

Arch 系统安装脚本保留在 `systems/arch/install`；Linux / macOS 软件列表在 `systems/`。
工具版本编辑 `home/config/mise/config.toml`。`install-mise` 使用官方 `https://mise.run`，
默认安装到 `~/.local/bin/mise`。

## 检查

```sh
./tests/smoke.sh
./tests/pre-commit worktree
```

冒烟测试使用临时 HOME，不修改当前用户配置。需要提交时自动检查敏感信息，可手动启用：

```sh
git config core.hooksPath tests
```
