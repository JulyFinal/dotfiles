#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
test_root=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-smoke.XXXXXX")
trap 'rm -rf "$test_root"' EXIT HUP INT TERM

for script in \
    "$repo_dir/dotfiles" \
    "$repo_dir/setup" \
    "$repo_dir/scripts/install-mise" \
    "$repo_dir/config/mise/tasks/skills-sync"; do
    sh -n "$script"
done
bash -n "$repo_dir/systems/arch/install"

"$repo_dir/tests/pre-commit" worktree

test ! -e "$repo_dir/.chezmoi.toml.tmpl"
test ! -e "$repo_dir/.chezmoiignore"
test ! -e "$repo_dir/.gitattributes"
test -f "$repo_dir/config/mise/config.toml"
test -x "$repo_dir/config/mise/tasks/skills-sync"
test -f "$repo_dir/config/shell/zshrc"
test -f "$repo_dir/config/nvim/init.lua"
test -f "$repo_dir/config/agents/codex/config.toml.j2"
test -f "$repo_dir/config/agents/pi/agent/mcp.json.j2"
test -f "$repo_dir/config/README.md"
test -z "$(find "$repo_dir/config" -name '.*' -print -quit)"
test -f "$repo_dir/manifests/agent-skills.yaml"
test -f "$repo_dir/manifests/files.yaml"
test -f "$repo_dir/systems/arch/packages/common.txt"
test -f "$repo_dir/minijinja.toml"
test -f "$repo_dir/secrets.example.toml"
test ! -e "$repo_dir/examples/mihomo"
! grep -Fq '[mihomo]' "$repo_dir/secrets.example.toml"
test ! -e "$repo_dir/personal"
test ! -e "$repo_dir/overlays"
test ! -e "$repo_dir/deploy.conf"
test ! -e "$repo_dir/home"
test ! -e "$repo_dir/bootstrap"
test ! -e "$repo_dir/doctor"
test ! -e "$repo_dir/scripts/install-latest-git"
test ! -e "$repo_dir/manifests/latest-git.conf"
git -C "$repo_dir" check-ignore -q --no-index secrets.toml

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
test "$(tail -n 1 "$repo_dir/config/shell/entrypoints/zshrc")" != '# third-party installer line'
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
test -L "$personal_home/.config/yazi/flavors/catppuccin-mocha.yazi/tmtheme.xml"
test -f "$personal_home/.codex/config.toml"
test ! -L "$personal_home/.codex/config.toml"
grep -Fq "$personal_home/.local/share/mise/shims/context7-mcp" \
    "$personal_home/.codex/config.toml"
! grep -Fq '[marketplaces.waza]' "$personal_home/.codex/config.toml"
! grep -Fq '[marketplaces.kami]' "$personal_home/.codex/config.toml"
! grep -Fq 'waza@waza' "$personal_home/.codex/config.toml"
! grep -Fq 'kami@kami' "$personal_home/.codex/config.toml"
test "$(stat -c '%a' "$personal_home/.codex/config.toml" 2>/dev/null || stat -f '%Lp' "$personal_home/.codex/config.toml")" = 600

macos_home=$test_root/macos
mkdir -p "$macos_home"
DOTFILES_HOME="$macos_home" DOTFILES_PLATFORM=macos \
    "$repo_dir/dotfiles" apply personal --yes >/dev/null

DOTFILES_HOME="$personal_home" DOTFILES_PLATFORM=linux \
    "$repo_dir/dotfiles" doctor core personal >"$test_root/doctor"
grep -Fq '0 drifted or missing path(s).' "$test_root/doctor"

chmod 0644 "$personal_home/.codex/config.toml"
DOTFILES_HOME="$personal_home" DOTFILES_PLATFORM=linux \
    "$repo_dir/dotfiles" plan personal >"$test_root/plan-mode"
grep -Fq "REPLACE  $personal_home/.codex/config.toml  (template)" \
    "$test_root/plan-mode"
if DOTFILES_HOME="$personal_home" DOTFILES_PLATFORM=linux \
    "$repo_dir/dotfiles" doctor personal >"$test_root/doctor-mode" 2>&1; then
    printf '%s\n' 'doctor unexpectedly ignored a mode drift' >&2
    exit 1
fi
grep -Fq "DRIFT    $personal_home/.codex/config.toml" "$test_root/doctor-mode"
DOTFILES_HOME="$personal_home" DOTFILES_PLATFORM=linux \
    "$repo_dir/dotfiles" apply personal --yes >/dev/null

DOTFILES_HOME="$personal_home" DOTFILES_PLATFORM=linux \
    "$repo_dir/dotfiles" explain "$personal_home/.zshrc" >"$test_root/explain"
grep -Fq "Target:   $personal_home/.zshrc" "$test_root/explain"
grep -Fq 'Platform: linux' "$test_root/explain"
grep -Fq 'Method:   copy' "$test_root/explain"

setup_home=$test_root/setup
mkdir -p "$setup_home"
printf 'y\n' \
    | DOTFILES_HOME="$setup_home" \
        DOTFILES_PLATFORM=macos \
        DOTFILES_SETUP_SELECTION='1' \
        "$repo_dir/setup" >"$test_root/setup-output"
test -f "$setup_home/.zshrc"
grep -Fq 'Personal Environment Kit' "$test_root/setup-output"
grep -Fq 'Platform  macOS' "$test_root/setup-output"

secret_manifest=$test_root/secret-manifest.yaml
secret_target=$test_root/secret-target
mkdir -p "$secret_target"
printf '%s\n' \
    'version: 1' \
    'groups:' \
    '  - id: secrets' \
    '    label: Secret fixture' \
    'entries:' \
    '  - id: secret.fixture' \
    '    group: secrets' \
    '    source: tests/fixtures/secret.toml.j2' \
    '    target: .config/example/config.toml' \
    '    method: template' \
    '    mode: "0600"' \
    '    requires: [minijinja-cli]' \
    >"$secret_manifest"
printf '%s\n' \
    '[example]' \
    'subscription_url = "https://example.invalid/latest"' \
    >"$test_root/secrets.toml"
DOTFILES_HOME="$secret_target" \
    DOTFILES_MANIFEST_FILE="$secret_manifest" \
    DOTFILES_SECRETS_FILE="$test_root/secrets.toml" \
    DOTFILES_PLATFORM=linux \
    "$repo_dir/dotfiles" apply secrets --yes >/dev/null
grep -Fq 'https://example.invalid/latest' \
    "$secret_target/.config/example/config.toml"
test "$(stat -c '%a' "$secret_target/.config/example/config.toml" 2>/dev/null || stat -f '%Lp' "$secret_target/.config/example/config.toml")" = 600

if command -v taplo >/dev/null 2>&1; then
    taplo check --no-schema "$repo_dir/minijinja.toml"
    taplo check --no-schema "$repo_dir/secrets.example.toml"
    find "$repo_dir/config" -type f -name '*.toml' \
        | while IFS= read -r toml_file; do
            taplo check --no-schema "$toml_file"
        done

fi

if command -v yq >/dev/null 2>&1; then
    yq -e '.version == 1' "$repo_dir/manifests/agent-skills.yaml" >/dev/null
    yq -e '.version == 1 and (.entries | length > 0)' \
        "$repo_dir/manifests/files.yaml" >/dev/null
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
