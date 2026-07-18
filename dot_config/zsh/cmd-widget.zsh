# cmd-widget.zsh — 轻量命令速查工具（zsh widget）

_CMD_DIR="$HOME/.config/zsh/commands"

cmd-widget() {
    local line encoded cmd missing

    missing=()
    (( $+commands[fzf] )) || missing+=(fzf)
    (( $+commands[yq] ))  || missing+=(yq)
    if (( ${#missing[@]} > 0 )); then
        zle -M "cmd-widget: missing: ${missing[*]}"
        zle redisplay
        return
    fi

    line=$(
        yq -r '
          .[] |
          select(.name and .cmd) |
          (
            "[" + ((.tags // []) | join(",")) + "] " + .name
            + " :: " + (.cmd | gsub("\n$"; "") | gsub("\n"; " ; "))
          ) + "\t" + (.cmd | @base64)
        ' "$_CMD_DIR"/*.yaml(N) 2>/dev/null \
        | fzf --prompt='cmd> ' \
              --delimiter=$'\t' --with-nth=1 \
              --query="${BUFFER:-}"
    ) || { zle redisplay; return }

    [[ -z "$line" ]] && { zle redisplay; return }

    encoded="${line##*$'\t'}"
    cmd="$(printf '%s' "$encoded" | base64 -d)"

    BUFFER="$cmd"
    CURSOR=${#BUFFER}
    zle redisplay
}

zle -N cmd-widget
bindkey '^G' cmd-widget
