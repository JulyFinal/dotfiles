#!/bin/sh
set -eu
repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
workspace=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-test.XXXXXX")
trap 'rm -rf "$workspace"' EXIT HUP INT TERM
export HOME=$workspace/test-home
mkdir -p "$HOME/.config/mise" "$HOME/.config/nvim" "$HOME/.pi/agent"
printf '%s\n' '# machine shell settings' >"$HOME/.zshrc"
printf '%s\n' 'old configuration' >"$HOME/.config/mise/config.toml"
printf '%s\n' 'local runtime state' >"$HOME/.config/nvim/lazy-lock.json"
printf '%s\n' '{}' >"$HOME/.pi/agent/settings.json"
ln -s "$workspace/missing-old-source" "$HOME/.tmux.conf"

"$repo_dir/setup" >"$workspace/first-run"
find "$repo_dir/home" -type f | while IFS= read -r source; do
    relative=${source#"$repo_dir/home/"}
    case "$relative" in .bashrc | .profile | .zshrc) continue ;; esac
    test "$(readlink "$HOME/$relative")" = "$source"
done
grep -Fqx '# machine shell settings' "$HOME/.zshrc"
grep -Fqx 'local runtime state' "$HOME/.config/nvim/lazy-lock.json"
test ! -L "$HOME/.zshrc"
cp "$HOME/.zshrc" "$workspace/zshrc-first"
"$repo_dir/setup" >"$workspace/second-run"
cmp "$HOME/.zshrc" "$workspace/zshrc-first"

# Existing shell links are detached so injection never edits their source.
printf '%s\n' '# external shell settings' >"$workspace/external-bashrc"
cp "$workspace/external-bashrc" "$workspace/bashrc-original"
rm "$HOME/.bashrc"
ln -s "$workspace/external-bashrc" "$HOME/.bashrc"
"$repo_dir/setup" >"$workspace/shell-link-run"
test ! -L "$HOME/.bashrc"
cmp "$workspace/external-bashrc" "$workspace/bashrc-original"
grep -Fqx '# external shell settings' "$HOME/.bashrc"

# Conflicting directories are preserved and reported.
rm "$HOME/.config/starship.toml"
mkdir "$HOME/.config/starship.toml"
if "$repo_dir/setup" >"$workspace/directory-conflict" 2>&1; then
    printf '%s\n' 'FAIL: setup accepted a directory in place of a file' >&2
    exit 1
fi
test -d "$HOME/.config/starship.toml"
rmdir "$HOME/.config/starship.toml"

# Never follow a parent link into a separate checkout/configuration tree.
mv "$HOME/.config/mise" "$workspace/external-mise"
ln -s "$workspace/external-mise" "$HOME/.config/mise"
if "$repo_dir/setup" >"$workspace/parent-conflict" 2>&1; then
    printf '%s\n' 'FAIL: setup followed a parent directory symlink' >&2
    exit 1
fi
grep -q 'Directory symlink needs manual migration' "$workspace/parent-conflict"
test -L "$workspace/external-mise/config.toml"

sh -n "$repo_dir/setup" "$repo_dir/scripts/install-mise" \
    "$repo_dir/home/.config/mise/tasks/skills-sync"
printf '%s\n' 'smoke tests passed'
