# Navi duplicate and unsafe cheats

Status: needs-triage

## 问题

`config/navi/cheats/personal.cheat` 中 `% git, init` 与 `% git` 重复保存同一组 Git 全局配置命令；同时 `credential.helper store` 会把凭证明文写入 `~/.git-credentials`，不适合作为跨机器可复用的默认 cheat。`rclone serve http` 已标为 legacy，且当前仓库没有对应安装声明。

## 建议方案

1. 保留一个 Git 配置入口，删除重复块。
2. 从通用 cheat 中移除 `credential.helper store`；如仍需要，另建明确命名的本机私有操作说明，并在执行前提示明文风险。
3. 暂不删除整个 fileserver cheat；先保留 Caddy/Python 两个仍可能有用的临时服务器命令，单独确认 rclone 是否还需要后再删。

## 验证

用 `navi` 检查搜索结果只剩一个 Git 配置入口；确认剩余命令不依赖新增软件包，也不包含密码、Token 或固定私人路径。

## Comments

- 2026-07-31：由全仓库审计建立；未修改 Navi cheat。
