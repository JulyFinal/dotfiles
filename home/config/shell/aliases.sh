# Shared commands for bash and zsh.
# Proxy settings live here; eproxy accepts an optional complete proxy URL.

# Remove old aliases when reloading an already-open terminal.
unalias eproxy dproxy nproxy unproxy checkproxy 2>/dev/null || true

_proxy_release() {
    if [ "${_DPROXY_OWNER:-}" = "$$" ] && [ "${1:-}" != socks5h://127.0.0.1:10818 ]; then
        "$HOME/.local/bin/dproxy" stop "$$" || return
        unset _DPROXY_OWNER
    fi
    if [ "${_NPROXY_OWNER:-}" = "$$" ] && [ "${1:-}" != socks5h://127.0.0.1:10809 ]; then
        "$HOME/.local/bin/nproxy" stop "$$" || return
        unset _NPROXY_OWNER
    fi
}

dproxy() {
    "$HOME/.local/bin/dproxy" start "$$" || return
    eproxy socks5h://127.0.0.1:10818
    _DPROXY_OWNER=$$
}

nproxy() {
    "$HOME/.local/bin/nproxy" start "$$" || return
    eproxy socks5h://127.0.0.1:10809
    _NPROXY_OWNER=$$
}

eproxy() {
    _proxy_release "${1:-}" || return
    export http_proxy="${1:-socks5h://127.0.0.1:10808}"
    export https_proxy="$http_proxy" all_proxy="$http_proxy"
    export HTTP_PROXY="$http_proxy" HTTPS_PROXY="$http_proxy" ALL_PROXY="$http_proxy"
    export no_proxy=localhost,127.0.0.1,::1,192.168.0.0/16
    export NO_PROXY="$no_proxy"
    printf '🔗 代理已启用: %s\n' "$http_proxy"
}

unproxy() {
    _proxy_release || return
    unset HTTP_PROXY HTTPS_PROXY ALL_PROXY http_proxy https_proxy all_proxy NO_PROXY no_proxy
    printf '%s\n' '🔓 代理已禁用'
}

checkproxy() {
    local proxy_url="${HTTPS_PROXY:-${https_proxy:-${HTTP_PROXY:-${http_proxy:-${ALL_PROXY:-${all_proxy:-}}}}}}"
    if [ -n "$proxy_url" ]; then
        printf '🔗 代理已启用: %s (NO_PROXY=%s)\n' "$proxy_url" "${NO_PROXY:-${no_proxy:-}}"
    else
        printf '%s\n' '🔓 代理未启用'
    fi
}

alias browser='docker run --rm -ti fathyb/carbonyl'
alias du='du -sh'
alias gc='git commit -m'
alias gdiff='git diff --name-only --relative --diff-filter=d | xargs bat --diff'
alias glog='git log --pretty=oneline'
alias ll='ls -lh --color=auto'
alias lla='ls -alh --color=auto'
alias ls='ls -h --color=auto'
alias pc='proxychains4 -q'
alias pipcn='uv pip install -i https://pypi.tuna.tsinghua.edu.cn/simple'
alias tt='tmux attach -t $(tmux ls | cut -d: -f1 | fzf)'
alias zshreload='source ~/.zshrc'
