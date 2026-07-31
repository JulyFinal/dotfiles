# Yazi package ownership cleanup

Status: resolved

## 问题

当前 `config/yazi/package.toml` 已声明并锁定 bunny 与 Catppuccin flavor，但仓库又把同一批第三方插件/主题的运行文件、README、LICENSE 和预览图全部放进 `config/yazi/` 并逐个部署。`bookmarks.yazi` 还没有被 `init.lua`、`keymap.toml` 或 `package.toml` 引用。

审计证据：

- `ya pkg list` 只显示 `stelcodes/bunny` 与 `yazi-rs/flavors:catppuccin-mocha`。
- 当前用户配置只调用 `require("bunny")` 和 `plugin bunny`。
- Yazi vendored 目录约占 836KB，其中 `preview.png` 约 676KB。

## 建议方案

以 Yazi 官方 `package.toml`/`ya pkg install` 作为第三方依赖的唯一来源，并把用户配置收缩到最小：

1. 删除未启用的 `config/yazi/plugins/bookmarks.yazi/` 及其 manifest 条目。
2. 删除仓库内 bunny/flavor 的 vendored 运行文件、README、LICENSE 和预览图。
3. 删除当前只服务于 bunny、快捷键和自定义 opener 的 `init.lua`、`keymap.toml`、`yazi.toml` 及其 manifest 条目。
4. 只保留 `config/yazi/theme.toml` 和 `config/yazi/package.toml`：前者选择 flavor，后者记录锁定的依赖版本。
5. 增加显式的 `dotfiles install yazi`（或等价的安装菜单项），先确保 Mise 的 yazi 可用，再执行 `ya pkg install`；不得让 `apply` 自动联网。
6. 在 README 和 smoke test 中明确：`apply personal` 只部署两个入口，完整 Yazi 使用还需要显式安装包依赖。

## 为什么不继续双轨保留

同时保留 `package.toml` 和 vendored 依赖会形成两份来源：更新、版本、文件内容和实际运行状态可能互相漂移，也让 `config/` 看起来像下载缓存而不是用户配置中心。`yazi.toml`、`keymap.toml` 和 `init.lua` 当前没有其他用户行为需要保留。

## 风险与验证

该方案假设当前 Yazi 版本会按 `package.toml` 的 rev/hash 正常安装依赖。实现时必须在临时 HOME 中验证：先 `apply personal`，再显式安装 Yazi 包，启动 Yazi 能加载 bunny 与 flavor；离线时 `apply` 仍能完成但应明确提示依赖尚未安装。若官方包安装不能稳定复现，再退回“保留 vendored 运行文件、删除 package.toml”的单轨方案。

## 不在本任务

Helix、Mihomo、当前 HOME 的残留链接和 Pi/Codex 私有配置。

## Comments

- 2026-07-31：已按最小方案实现；隔离 HOME 的真实 `ya pkg install` 成功，smoke/pre-commit/语法检查均通过。
