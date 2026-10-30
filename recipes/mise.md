# Mise

先链接配置，再按需安装工具：

```sh
./setup
./scripts/install-mise
export PATH="$HOME/.local/bin:$PATH"
mise trust ~/.config/mise/config.toml
mise install
```

工具声明直接编辑 `home/.config/mise/config.toml`。
`install-mise` 使用官方 `https://mise.run`，安装到 `~/.local/bin/mise`。

Yazi 的插件与主题：

```sh
ya pkg install
```

Agent skills 的来源和目标保留在 `manifests/agent-skills.yaml`：

```sh
mise run skills-sync -- --dry-run
mise run skills-sync
```
