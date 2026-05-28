# cmd-widget.zsh — 轻量命令速查工具（zsh widget）
#
# 安装：
#   在 ~/.zshrc 中加入：
#
#     source ~/dotfiles/scripts/cmd-widget.zsh
#
#  然后 source ~/.zshrc 或开新终端生效。
#
# 默认快捷键 Ctrl-G。
#   如果 Ctrl-G 没反应，先检查终端 stty 是否占用了此键：
#
#     stty -a | grep quit
#
#   若显示 quit = ^G，说明终端驱动层拦截了按键。两种解法：
#
#     1. 在 ~/.zshrc 末尾加一行： stty quit undef 2>/dev/null
#     2. 或改用其他快捷键，改本文件末尾的 bindkey，例如 '^K'
#
# 命令条目存放在 scripts/commands/*.tsv 中。
#
# 格式：TSV（每行一个命令）
#   描述<TAB>命令
#
#   # 开头的行为注释，空行被忽略，无 TAB 的行被跳过。
#
# 依赖：awk, fzf
#
# 为什么用 TSV 而非 Markdown：
#   - 不需要 rg 依赖，awk 更通用
#   - TAB 作为分隔符天然不和命令内容冲突
#   - 格式更简单，维护成本更低
#   - fzf 无需 --delimiter 即可以原始行展示

# 解析本文件所在目录（source 时 $0 即为本文件路径）
_CMD_DIR="${0:A:h}/commands"

# 内部：检查依赖（只检查一次，失败后不再重复）
_cmd-check-deps() {
    if [[ -n "${_CMD_DEPS_CHECKED:-}" ]]; then
        [[ "$_CMD_DEPS_CHECKED" == "ok" ]]
        return
    fi

    if ! (( $+commands[fzf] )); then
        zle -M "cmd-widget: fzf not installed. e.g. sudo pacman -S fzf"
        _CMD_DEPS_CHECKED=fail
        return 1
    fi

    if [[ ! -d "$_CMD_DIR" ]]; then
        zle -M "cmd-widget: commands dir not found: $_CMD_DIR"
        _CMD_DEPS_CHECKED=fail
        return 1
    fi

    _CMD_DEPS_CHECKED=ok
}

# 主 widget：搜索命令并插入当前 BUFFER
cmd-widget() {
    local line cmd

    _cmd-check-deps || { zle redisplay; return; }

    line=$(
        awk -F '\t' '
            NF >= 2 && $1 !~ /^#/ && $1 != "" {
                print $0
            }
        ' "$_CMD_DIR"/*.tsv 2>/dev/null \
        | fzf --prompt='cmd> ' --query="${BUFFER:-}"
    ) || return

    [[ -z "$line" ]] && return

    cmd="${line#*$'\t'}"
    BUFFER="$cmd"
    CURSOR=${#BUFFER}
    zle redisplay
}

zle -N cmd-widget
bindkey '^G' cmd-widget
