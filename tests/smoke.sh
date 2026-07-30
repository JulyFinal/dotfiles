#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
test_root=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-smoke.XXXXXX")
trap 'rm -rf "$test_root"' EXIT HUP INT TERM

for script in \
    "$repo_dir/dotfiles" \
    "$repo_dir/setup" \
    "$repo_dir/bootstrap" \
    "$repo_dir/doctor" \
    "$repo_dir/scripts/install-mise" \
    "$repo_dir/scripts/install-latest-git" \
    "$repo_dir/home/.config/mise/tasks/skills-sync"; do
    sh -n "$script"
done
bash -n "$repo_dir/systems/arch/install"

"$repo_dir/tests/pre-commit" worktree

test ! -e "$repo_dir/.chezmoi.toml.tmpl"
test ! -e "$repo_dir/.chezmoiignore"
test -f "$repo_dir/home/.config/mise/config.toml"
test -x "$repo_dir/home/.config/mise/tasks/skills-sync"
test -f "$repo_dir/home/.config/shell/zshrc"
test -f "$repo_dir/manifests/agent-skills.yaml"
test -f "$repo_dir/personal/home/.config/nvim/init.lua"
test -f "$repo_dir/systems/arch/packages/common.txt"
grep -Fq 'copy         .zshrc' "$repo_dir/deploy.conf"
grep -Fq 'template     .codex/config.toml' "$repo_dir/deploy.conf"

core_home=$test_root/core
mkdir -p "$core_home"
DOTFILES_HOME="$core_home" DOTFILES_PLATFORM=linux \
    "$repo_dir/dotfiles" plan core >"$test_root/core-plan"
grep -Fq "CREATE   $core_home/.zshrc  (copy)" "$test_root/core-plan"
test ! -e "$core_home/.zshrc"

DOTFILES_HOME="$core_home" DOTFILES_PLATFORM=linux \
    "$repo_dir/dotfiles" apply core --yes >"$test_root/core-apply"
test -f "$core_home/.zshrc"
test ! -L "$core_home/.zshrc"
test -L "$core_home/.config/shell/zshrc"
test -L "$core_home/.config/mise/tasks/skills-sync"
test -L "$core_home/.tmux.conf"
test -L "$core_home/.local/share/navi/cheats/personal.cheat"
grep -Fq 'source "$HOME/.config/shell/zshrc"' "$core_home/.zshrc"

printf '%s\n' '# third-party installer line' >>"$core_home/.zshrc"
test "$(tail -n 1 "$repo_dir/home/.zshrc")" != '# third-party installer line'
DOTFILES_HOME="$core_home" DOTFILES_PLATFORM=linux \
    "$repo_dir/dotfiles" plan core >"$test_root/core-drift"
grep -Fq -- '-# third-party installer line' "$test_root/core-drift"
DOTFILES_HOME="$core_home" DOTFILES_PLATFORM=linux \
    "$repo_dir/dotfiles" apply core --yes >/dev/null
! grep -Fq '# third-party installer line' "$core_home/.zshrc"

personal_home=$test_root/personal
mkdir -p "$personal_home"
DOTFILES_HOME="$personal_home" DOTFILES_PLATFORM=linux \
    "$repo_dir/dotfiles" apply core personal --yes >/dev/null
test -L "$personal_home/.config/nvim/init.lua"
test -L "$personal_home/.config/systemd/user/mihomo.service"
test -f "$personal_home/.codex/config.toml"
test ! -L "$personal_home/.codex/config.toml"
grep -Fq "$personal_home/.local/share/mise/shims/context7-mcp" \
    "$personal_home/.codex/config.toml"
! grep -Fq '[marketplaces.waza]' "$personal_home/.codex/config.toml"
! grep -Fq '[marketplaces.kami]' "$personal_home/.codex/config.toml"
! grep -Fq 'waza@waza' "$personal_home/.codex/config.toml"
! grep -Fq 'kami@kami' "$personal_home/.codex/config.toml"
test "$(stat -c '%a' "$personal_home/.codex/config.toml" 2>/dev/null || stat -f '%Lp' "$personal_home/.codex/config.toml")" = 600

DOTFILES_HOME="$personal_home" DOTFILES_PLATFORM=linux \
    "$repo_dir/dotfiles" doctor core personal >"$test_root/doctor"
grep -Fq '0 drifted or missing path(s).' "$test_root/doctor"

DOTFILES_HOME="$personal_home" DOTFILES_PLATFORM=linux \
    "$repo_dir/dotfiles" explain "$personal_home/.zshrc" >"$test_root/explain"
grep -Fq 'Method:   copy' "$test_root/explain"

private_source=$test_root/private-home
private_target=$test_root/private-target
mkdir -p "$private_source/.config/example" "$private_target"
printf '%s\n' 'private=true' >"$private_source/.config/example/config"
DOTFILES_HOME="$private_target" \
    DOTFILES_PRIVATE_HOME="$private_source" \
    DOTFILES_PLATFORM=macos \
    "$repo_dir/dotfiles" apply private --yes >/dev/null
test -f "$private_target/.config/example/config"
test ! -L "$private_target/.config/example/config"
test "$(stat -c '%a' "$private_target/.config/example/config" 2>/dev/null || stat -f '%Lp' "$private_target/.config/example/config")" = 644

setup_home=$test_root/setup
mkdir -p "$setup_home"
printf 'y\n' \
    | DOTFILES_HOME="$setup_home" \
        DOTFILES_PLATFORM=macos \
        DOTFILES_SETUP_SELECTION='1' \
        "$repo_dir/setup" >"$test_root/setup-output"
test -f "$setup_home/.zshrc"
grep -Fq 'Personal Environment Kit' "$test_root/setup-output"

if command -v taplo >/dev/null 2>&1; then
    find "$repo_dir/home" "$repo_dir/personal/home" -type f -name '*.toml' \
        | while IFS= read -r toml_file; do
            [ "$toml_file" = "$repo_dir/personal/home/.codex/config.toml" ] \
                && continue
            taplo check --no-schema "$toml_file"
        done

    template_root=$test_root/private-templates
    secrets_file=$test_root/secrets.toml
    secret_target=$test_root/secret-target
    mkdir -p "$template_root/.config/example" "$secret_target"
    printf '%s\n' 'url = "@SECRET:mihomo.subscription_url@"' \
        >"$template_root/.config/example/config.toml"
    printf '%s\n' \
        '[mihomo]' \
        'subscription_url = "https://example.invalid/latest"' \
        >"$secrets_file"
    DOTFILES_HOME="$secret_target" \
        DOTFILES_PRIVATE_TEMPLATES="$template_root" \
        DOTFILES_PRIVATE_HOME="$test_root/no-private-home" \
        DOTFILES_SECRETS_FILE="$secrets_file" \
        DOTFILES_PLATFORM=linux \
        "$repo_dir/dotfiles" apply private --yes >/dev/null
    grep -Fq 'https://example.invalid/latest' \
        "$secret_target/.config/example/config.toml"
fi

if command -v yq >/dev/null 2>&1; then
    yq -e '.version == 1' "$repo_dir/manifests/agent-skills.yaml" >/dev/null
    "$core_home/.config/mise/tasks/skills-sync" --dry-run \
        >"$test_root/skills-sync"
    grep -Fq 'tw93/Waza --global --agent codex claude-code pi' \
        "$test_root/skills-sync"
    grep -Fq 'tw93/kami/plugins/kami --global --agent codex claude-code pi' \
        "$test_root/skills-sync"
    grep -Fq 'mattpocock/skills --global --agent codex claude-code pi' \
        "$test_root/skills-sync"

    mock_bin=$test_root/mock-bin
    mock_log=$test_root/skills-sync-calls
    mkdir -p "$mock_bin"
    printf '%s\n' \
        '#!/bin/sh' \
        'printf "%s\n" "$*" >>"$SKILLS_SYNC_LOG"' \
        'cat >/dev/null' \
        >"$mock_bin/npx"
    chmod +x "$mock_bin/npx"
    PATH="$mock_bin:$PATH" SKILLS_SYNC_LOG="$mock_log" \
        "$core_home/.config/mise/tasks/skills-sync" >/dev/null
    test "$(wc -l <"$mock_log")" = 3
    grep -Fq 'add tw93/Waza --global --agent codex claude-code pi' "$mock_log"
    grep -Fq 'add tw93/kami/plugins/kami --global --agent codex claude-code pi' \
        "$mock_log"
    grep -Fq 'add mattpocock/skills --global --agent codex claude-code pi' \
        "$mock_log"
fi

python3 - "$personal_home/.pi/agent/mcp.json" \
    "$personal_home/.pi/agent/settings.json" <<'PY'
import json
import sys
from pathlib import Path

for name in sys.argv[1:]:
    json.loads(Path(name).read_text())
PY

printf '%s\n' 'dotfiles smoke test passed'
