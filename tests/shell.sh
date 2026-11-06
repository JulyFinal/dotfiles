#!/bin/sh
# Exercise shared shell configuration in isolated bash and zsh sessions.
set -eu
repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
workspace=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-shell.XXXXXX")
trap 'rm -rf "$workspace"' EXIT HUP INT TERM
export HOME=$workspace/home DOTFILES_TEST_REPO=$repo_dir
mkdir -p "$HOME/.local/bin" "$HOME/.local/share/mise/shims" "$HOME/.nix-profile/bin" "$HOME/.config/shell"
ln -s "$repo_dir/home/config/shell/aliases.sh" "$HOME/.config/shell/aliases.sh"
cat >"$workspace/check" <<'CHECK'
set -eu
. "$DOTFILES_TEST_REPO/home/config/shell/common.sh"
initial_path=$PATH
. "$DOTFILES_TEST_REPO/home/config/shell/common.sh"
if [ "$PATH" != "$initial_path" ]; then
    printf '%s\n' 'FAIL: sourcing common.sh twice changes PATH' >&2
    exit 1
fi
# eval also exercises the previous alias interface in interactive shells.
eval 'eproxy' >/dev/null
test "$HTTP_PROXY" = socks5h://127.0.0.1:10808
test "$http_proxy" = "$HTTP_PROXY"
test "$HTTPS_PROXY" = "$HTTP_PROXY"
test "$https_proxy" = "$HTTP_PROXY"
test "$ALL_PROXY" = "$HTTP_PROXY"
test "$all_proxy" = "$HTTP_PROXY"
test "$NO_PROXY" = localhost,127.0.0.1,::1,192.168.0.0/16
test "$no_proxy" = "$NO_PROXY"
eval 'eproxy http://127.0.0.1:7890' >/dev/null
test "$HTTP_PROXY" = http://127.0.0.1:7890
checkproxy | command grep -Fq "$HTTP_PROXY"
unproxy >/dev/null
test "${HTTP_PROXY+x}${http_proxy+x}${HTTPS_PROXY+x}${https_proxy+x}${ALL_PROXY+x}${all_proxy+x}${NO_PROXY+x}${no_proxy+x}" = ''
checkproxy | command grep -Fq '代理未启用'
CHECK
for shell in bash zsh; do
    if command -v "$shell" >/dev/null 2>&1; then
        "$shell" "$workspace/check"
        printf '%s shell checks passed\n' "$shell"
    else
        printf '%s shell checks skipped (not installed)\n' "$shell"
    fi
done

# Shell startup without a terminal must not initialize fzf's line editor.
if command -v zsh >/dev/null 2>&1; then
    ln -s "$repo_dir/home/config/shell/common.sh" "$HOME/.config/shell/common.sh"
    mkdir -p "$workspace/bin"
    cat >"$workspace/bin/fzf" <<'FZF'
#!/bin/sh
: >"$HOME/fzf-initialized"
FZF
    chmod +x "$workspace/bin/fzf"
    PATH="$workspace/bin:/usr/bin:/bin" zsh -f -c \
        '. "$DOTFILES_TEST_REPO/home/zshrc"; whence -w eproxy' >"$workspace/startup-output"
    grep -Fqx 'eproxy: function' "$workspace/startup-output"
    if [ -e "$HOME/fzf-initialized" ]; then
        printf '%s\n' 'FAIL: fzf initialized without a terminal' >&2
        exit 1
    fi
    printf '%s\n' 'zsh startup without terminal passed'
fi
