#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
test_root=$(mktemp -d /tmp/dotfiles-smoke.XXXXXX)
trap 'rm -rf -- "$test_root"' EXIT

bash -n "$repo_dir/bootstrap" "$repo_dir/doctor"
for script in "$repo_dir"/private_dot_local/bin/executable_*; do
    sh -n "$script"
done

python3 - "$repo_dir" <<'PY'
import json
import sys
import tomllib
from pathlib import Path

root = Path(sys.argv[1])
for path in root.rglob("*.toml"):
    if "archive" not in path.parts:
        tomllib.loads(path.read_text())
json.loads((root / "dot_config/nvim/lazy-lock.json").read_text())
vicinae = (root / "dot_config/vicinae/settings.json").read_text()
json.loads("\n".join(line for line in vicinae.splitlines() if not line.lstrip().startswith("//")))
PY

for profile in laptop desktop; do
    destination="$test_root/$profile"
    mkdir -p "$destination"
    chezmoi --source "$repo_dir" --destination "$destination" \
        --override-data "{\"profile\":\"$profile\"}" apply --force
    niri validate --config "$destination/.config/niri/config.kdl"
done

for lua_file in "$repo_dir"/dot_config/nvim/init.lua "$repo_dir"/dot_config/nvim/lua/*.lua; do
    nvim --headless -u NONE "+lua assert(loadfile('$lua_file'))" '+qa'
done

printf '%s\n' 'dotfiles smoke test passed'
