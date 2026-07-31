# 配置重复项收敛

## 目标

把已经确认是重复所有权、未启用或只属于第三方包元数据的内容从日常配置视图中拿掉，同时保留临时机器可用、`apply` 离线和差异可见这几个边界。

## 本轮范围

- Yazi：收缩为 `theme.toml` 与 `package.toml` 两个最小入口；插件、flavor 和其他行为配置都不在当前版本管理。
- Navi：处理重复的 Git cheat，以及不适合放在可复用 cheat 中的明文凭证命令。

## 明确不在本轮

- Helix snippets 和 `simple-completion-language-server` 依赖，单独延期。
- 不删除当前 HOME 下仍在运行的 Mihomo 服务或本机私有配置。
- 不覆盖 Codex/Pi 当前本机配置；后续执行时仍必须先展示 diff。

## 设计原则

`config/` 只保留用户实际编辑的配置和必要的依赖声明；第三方包通过其官方安装入口获取。网络安装必须是显式动作，`apply` 仍然只做本地映射/渲染。
