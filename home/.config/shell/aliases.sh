# Shell aliases — migrated from atuin dotfiles store (2026-09-24).
# atuin 18.23 no longer applies stored aliases on shell init, so they live here.
# Sourced by common.sh (both zsh and bash entrypoints).

export LANGUAGE=en

alias browser='docker run --rm -ti fathyb/carbonyl'
alias checkproxy='proxy_url="${HTTPS_PROXY:-${https_proxy:-}}"; if [ -n "$proxy_url" ]; then echo "🔗 代理已启用: $proxy_url (NO_PROXY=${NO_PROXY:-${no_proxy:-}})"; else echo "🔓 代理未启用"; fi; unset proxy_url'
alias du='du -sh'
alias eproxy='export HTTP_PROXY=socks5://127.0.0.1:10808 HTTPS_PROXY=socks5://127.0.0.1:10808 ALL_PROXY=socks5://127.0.0.1:10808 http_proxy=socks5://127.0.0.1:10808 https_proxy=socks5://127.0.0.1:10808 all_proxy=socks5://127.0.0.1:10808 NO_PROXY=localhost,127.0.0.1,::1 no_proxy=localhost,127.0.0.1,::1; echo "🔗 SOCKS5 代理已启用: 127.0.0.1:10808"'
alias gc='git commit -m'
alias gdiff='git diff --name-only --relative --diff-filter=d | xargs bat --diff'
alias glog='git log --pretty=oneline'
alias ll='ls -lh --color=auto'
alias lla='ls -alh --color=auto'
alias ls='ls -h --color=auto'
alias pc='proxychains4 -q'
alias pipcn='uv pip install -i https://pypi.tuna.tsinghua.edu.cn/simple'
alias tt='tmux attach -t $(tmux ls | cut -d: -f1 | fzf)'
alias unproxy='unset HTTP_PROXY HTTPS_PROXY ALL_PROXY http_proxy https_proxy all_proxy NO_PROXY no_proxy; echo "🔓 代理已禁用"'
alias zshreload='source ~/.zshrc'
