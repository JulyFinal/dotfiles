#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
test_root=$(mktemp -d /tmp/dotfiles-smoke.XXXXXX)
trap 'rm -rf -- "$test_root"' EXIT

bash -n "$repo_dir/bootstrap" "$repo_dir/doctor"
PYTHONPYCACHEPREFIX="$test_root/pycache" python3 -m py_compile "$repo_dir/tests/pre-commit"
"$repo_dir/tests/pre-commit" worktree
if [[ -d "$repo_dir/private_dot_local/bin" ]]; then
    for script in "$repo_dir"/private_dot_local/bin/executable_*; do
        [[ -e "$script" ]] && sh -n "$script"
    done
fi
while IFS= read -r -d '' toml_file; do
    taplo check "$toml_file"
done < <(find "$repo_dir" -type f -name '*.toml' -print0)

python3 - "$repo_dir" <<'PY'
import json
import sys
from pathlib import Path

root = Path(sys.argv[1])
json.loads((root / "dot_config/nvim/lazy-lock.json").read_text())
vicinae = (root / "dot_config/vicinae/settings.json").read_text()
vicinae_config = json.loads(
    "\n".join(line for line in vicinae.splitlines() if not line.lstrip().startswith("//"))
)
assert vicinae_config["close_on_focus_loss"] is True
assert vicinae_config["launcher_window"]["layer_shell"]["keyboard_interactivity"] == "on_demand"
zed = (root / "dot_config/zed/private_settings.json").read_text()
zed_config = json.loads(
    "\n".join(line for line in zed.splitlines() if not line.lstrip().startswith("//"))
)
codex_env = zed_config["agent_servers"]["codex-acp"]["env"]
assert zed_config["proxy"] == "http://127.0.0.1:10808"
assert codex_env["HTTP_PROXY"] == codex_env["http_proxy"] == zed_config["proxy"]
assert codex_env["HTTPS_PROXY"] == codex_env["https_proxy"] == zed_config["proxy"]
assert codex_env["ALL_PROXY"] == codex_env["all_proxy"] == zed_config["proxy"]
assert codex_env["NO_PROXY"] == codex_env["no_proxy"] == "localhost,127.0.0.1,::1"
aur_packages = (root / "packages/aur.txt").read_text().splitlines()
user_services = (root / "services/user-common.txt").read_text().splitlines()
portable_user_services = (
    root / "services/user-portable.txt"
).read_text().splitlines()
assert "xembed-sni-proxy-standalone-git" not in aur_packages
assert "xembed-sni-proxy.service" not in user_services
pacman_packages = (root / "packages/pacman-common.txt").read_text().splitlines()
assert "wine-staging" not in pacman_packages and "winetricks" not in pacman_packages
assert "kdeconnect" in pacman_packages
assert "mihomo-bin" in aur_packages and "metacubexd" not in aur_packages
desktop_packages = {
    "awww", "fcitx5", "greetd", "greetd-tuigreet", "hyprlock", "mako",
    "niri", "quickshell", "swayidle", "swaylock", "waybar", "xwayland-satellite",
}
assert desktop_packages.isdisjoint(pacman_packages)
assert "fcitx5-theme-wechat" not in aur_packages
assert "mihomo.service" in user_services
assert portable_user_services == ["mihomo.service"]
assert "vicinae.service" not in portable_user_services
assert "proxy-core.service" not in user_services and "v2rayn" not in aur_packages
retired_tools = {
    "firefox", "freerdp", "gtk-vnc", "helix", "imagemagick",
    "libvncserver", "remmina", "sshfs",
}
assert retired_tools.isdisjoint(pacman_packages)
assert "xray" not in aur_packages
assert "rclone" not in (root / "dot_config/mise/config.toml").read_text().splitlines()
assert 'navi = "latest"' in (root / "dot_config/mise/config.toml").read_text().splitlines()
assert "rclone-koofr.service" not in user_services
assert not (root / "dot_config/autostart/v2rayN.desktop.tmpl").exists()
assert not (root / "private_dot_local/bin/executable_v2rayn-background").exists()
mihomo_example = (root / "dot_config/mihomo/config.yaml.example").read_text()
mihomo_service = (root / "dot_config/systemd/user/mihomo.service").read_text()
mihomo_wrapper = (root / "private_dot_local/bin/executable_mihomo-managed").read_text()
mihomo_launchd = (
    root / "Library/LaunchAgents/private_io.github.metacubex.mihomo.plist.tmpl"
).read_text()
mihomo_subscription = (root / "private_dot_local/bin/executable_mihomo-subscription").read_text()
mihomo_ubuntu = (root / "private_dot_local/bin/executable_install-mihomo-ubuntu").read_text()
assert mihomo_example.count("url: https://xxxx.yyy") == 2
assert "secret: xxxx" in mihomo_example
assert "mixed-port: 10808" in mihomo_example
assert "port: 10809" not in mihomo_example and "socks-port:" not in mihomo_example
assert "mode: global" in mihomo_example
assert "unified-delay: true" in mihomo_example and "tcp-concurrent: true" in mihomo_example
assert "additional-prefix: '[mxlsub]'" in mihomo_example
assert "additional-prefix: '[pokemon]'" in mihomo_example
assert "rules:" not in mihomo_example
assert "tun:" not in mihomo_example and "dns:" not in mihomo_example
assert "sniffer:" not in mihomo_example and "geox-url:" not in mihomo_example
assert "mihomo-service" in mihomo_service and "/usr/bin/mihomo" not in mihomo_service
assert "metacubexd" not in mihomo_service.lower()
assert ".nix-profile/bin" in mihomo_wrapper and "/opt/homebrew/bin" in mihomo_wrapper
assert "io.github.metacubex.mihomo" in mihomo_launchd
assert "mihomo-service" in mihomo_launchd
assert "expected one URL for provider" in mihomo_subscription
assert "端口、UI/controller、密码和策略组保持不变" in mihomo_subscription
assert "proxyctl test" in mihomo_subscription
assert "work-openvpn" not in mihomo_example and "192.168.168.0/24,WORK" not in mihomo_example
assert not (root / "private_dot_local/bin/executable_mihomo-openvpn").exists()
assert "networkmanager-openvpn" not in pacman_packages and "openvpn" not in pacman_packages
assert "mihomo-linux-amd64-v1-" in mihomo_ubuntu
assert "sha256sum --check" in mihomo_ubuntu and "metacubexd" not in mihomo_ubuntu.lower()
assert "systemctl enable --now mihomo.service" in mihomo_ubuntu
desktop_paths = [
    "archive", "dot_config/greetd", "dot_config/hypr", "dot_config/mako",
    "dot_config/niri", "dot_config/private_fcitx5", "dot_config/quickshell",
    "dot_config/swaylock", "dot_config/waybar",
]
assert all(not (root / path).exists() for path in desktop_paths)
assert not (root / "dot_config/zsh/cmd-widget.zsh").exists()
assert not list((root / "dot_config/zsh/commands").glob("*.yaml"))
zshrc = (root / "dot_zshrc").read_text()
assert 'eval "$(navi widget zsh)"' in zshrc and "cmd-widget" not in zshrc
navi_cheat = (root / "private_dot_local/private_share/navi/cheats/personal.cheat").read_text()
assert sum(line.startswith("# ") for line in navi_cheat.splitlines()) == 15
assert "rclone 当前目录 http 服务 [legacy]" in navi_cheat
assert not (root / "dot_config/systemd/user/rclone-koofr.service").exists()
assert not (root / "private_dot_local/bin/executable_rdp-copy-image").exists()
gitignore = (root / ".gitignore").read_text()
assert "dot_config/mihomo/config.yaml" in gitignore and "*.ovpn" in gitignore
bootstrap = (root / "bootstrap").read_text()
assert "config core.hooksPath tests" in bootstrap
assert "brew update" in bootstrap and "brew upgrade" in bootstrap
assert "nixpkgs#$package" in bootstrap
assert "mapfile" not in bootstrap and "declare -A" not in bootstrap
assert "--platform is only allowed together with --dry-run" in bootstrap
nvim_plugins = (root / "dot_config/nvim/lua/plugins.lua").read_text()
assert '"folke/snacks.nvim"' in nvim_plugins
assert "Snacks.picker.files()" in nvim_plugins
assert "Snacks.picker.todo_comments()" in nvim_plugins
assert "Snacks.explorer.reveal()" in nvim_plugins
assert '"nvim-telescope/telescope.nvim"' not in nvim_plugins
assert '"nvim-neo-tree/neo-tree.nvim"' not in nvim_plugins
assert '"nvimdev/dashboard-nvim"' not in nvim_plugins
assert '"nvim-lua/plenary.nvim"' not in nvim_plugins
assert '"MunifTanjim/nui.nvim"' not in nvim_plugins
assert 'branch = "main"' in nvim_plugins
assert 'lazy = false' in nvim_plugins and 'build = ":TSUpdate"' in nvim_plugins
assert 'require("nvim-treesitter.configs")' not in nvim_plugins
assert 'legacy_parser_dir = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/parser"' in nvim_plugins
assert 'vim.fn.delete(legacy_parser_dir, "rf")' in nvim_plugins
assert '"numToStr/Comment.nvim"' not in nvim_plugins
assert '"neovim/nvim-lspconfig"' not in nvim_plugins
assert 'require("nvim-treesitter").install' in bootstrap
assert "TSUpdateSync" not in bootstrap
mise_config = (root / "dot_config/mise/config.toml").read_text().splitlines()
assert '"cargo:tree-sitter-cli" = { version = "0.26.11", default-features = false }' in mise_config
assert 'fd = "latest"' in mise_config
nix_packages = (root / "packages/nix-common.txt").read_text().splitlines()
brew_packages = (root / "packages/brew-common.txt").read_text().splitlines()
assert "mihomo" in nix_packages and "mise" in nix_packages
assert "mihomo" in brew_packages and "mise" in brew_packages
chezmoi_ignore = (root / ".chezmoiignore").read_text()
assert '.config/systemd/**' in chezmoi_ignore
assert 'Library/LaunchAgents/**' in chezmoi_ignore
assert '.config/vicinae/**' in chezmoi_ignore
pi_mcp = (root / "private_dot_pi/private_agent/private_mcp.json.tmpl").read_text()
assert "/home/final" not in pi_mcp
assert "{{ .chezmoi.homeDir }}" in pi_mcp
assert not (root / "private_dot_pi/private_agent/skills").exists()
pi_skills = (root / "packages/pi-skills.txt").read_text()
assert "codex-system" in pi_skills and "codex-plugin" in pi_skills
pi_skill_sync = (root / "scripts/sync-pi-skills").read_text()
assert "ln -s" in pi_skill_sync and "source unavailable" in pi_skill_sync
doctor = (root / "doctor").read_text()
assert 'tests/pre-commit" worktree' in doctor and 'tests/pre-commit" staged' in doctor
assert "launchctl print" in doctor and 'systemctl --user' in doctor
PY

macos_plan=$("$repo_dir/bootstrap" --dry-run --platform macos --profile portable)
grep -Fq 'Platform: macos' <<<"$macos_plan"
grep -Fq 'Homebrew formulae:' <<<"$macos_plan"
grep -Fq '  mihomo' <<<"$macos_plan"

linux_plan=$("$repo_dir/bootstrap" --dry-run --platform linux --profile portable)
grep -Fq 'Platform: linux' <<<"$linux_plan"
grep -Fq 'Nix profile packages:' <<<"$linux_plan"
grep -Fq '  mihomo' <<<"$linux_plan"

arch_plan=$("$repo_dir/bootstrap" --dry-run --platform arch --profile desktop)
grep -Fq 'Platform: arch' <<<"$arch_plan"
grep -Fq 'Pacman packages:' <<<"$arch_plan"
grep -Fq 'AUR packages:' <<<"$arch_plan"

if "$repo_dir/bootstrap" --platform macos --profile portable >/dev/null 2>&1; then
    printf '%s\n' 'bootstrap accepted a platform override without --dry-run' >&2
    exit 1
fi

python3 - "$repo_dir/Library/LaunchAgents/private_io.github.metacubex.mihomo.plist.tmpl" <<'PY'
import plistlib
import sys
from pathlib import Path

text = Path(sys.argv[1]).read_text().replace(
    "{{ .chezmoi.homeDir }}", "/Users/tester"
)
payload = plistlib.loads(text.encode())
assert payload["Label"] == "io.github.metacubex.mihomo"
assert payload["ProgramArguments"] == ["/Users/tester/.local/bin/mihomo-service"]
assert payload["KeepAlive"]["SuccessfulExit"] is False
PY

template_home="$test_root/template-home"
mkdir -p "$template_home"
touch "$template_home/empty-chezmoi.toml"
HOME="$template_home" chezmoi \
    --config "$template_home/empty-chezmoi.toml" \
    --source "$repo_dir" \
    execute-template \
    < "$repo_dir/private_dot_pi/private_agent/private_mcp.json.tmpl" \
    > "$test_root/pi-mcp.json"
python3 - "$test_root/pi-mcp.json" "$template_home" <<'PY'
import json
import sys
from pathlib import Path

config_path, home_path = map(Path, sys.argv[1:])
payload = json.loads(config_path.read_text())
servers = payload["mcpServers"]
assert servers["filesystem"]["args"] == [str(home_path)]
assert servers["atuin"]["command"] == str(
    home_path / ".local/share/mise/shims/atuin"
)
PY

for platform in macos linux arch; do
    platform_home="$test_root/platform-$platform"
    mkdir -p "$platform_home"
    printf '[data]\nplatform = "%s"\n' "$platform" \
        > "$platform_home/chezmoi.toml"
    HOME="$platform_home" chezmoi \
        --config "$platform_home/chezmoi.toml" \
        --source "$repo_dir" \
        --destination "$platform_home" \
        apply --force
done
test -f "$test_root/platform-macos/Library/LaunchAgents/io.github.metacubex.mihomo.plist"
test ! -e "$test_root/platform-macos/.config/systemd"
test ! -e "$test_root/platform-macos/.config/vicinae"
test ! -e "$test_root/platform-macos/.config/kdeglobals"
test ! -e "$test_root/platform-macos/.config/chrome-flags.conf"
test ! -e "$test_root/platform-macos/.config/fontconfig"
test ! -e "$test_root/platform-macos/.config/gtk-3.0"
test ! -e "$test_root/platform-macos/.config/gtk-4.0"
test -f "$test_root/platform-linux/.config/systemd/user/mihomo.service"
test ! -e "$test_root/platform-linux/Library/LaunchAgents"
test ! -e "$test_root/platform-linux/.config/vicinae"
test ! -e "$test_root/platform-linux/.config/kdeglobals"
test -f "$test_root/platform-linux/.config/chrome-flags.conf"
test -f "$test_root/platform-arch/.config/systemd/user/mihomo.service"
test ! -e "$test_root/platform-arch/Library/LaunchAgents"
test -d "$test_root/platform-arch/.config/vicinae"
test -f "$test_root/platform-arch/.config/kdeglobals"

url_update_root="$test_root/url-update"
mkdir -p "$url_update_root/config/mihomo" "$url_update_root/bin"
cp "$repo_dir/dot_config/mihomo/config.yaml.example" \
    "$url_update_root/config/mihomo/config.yaml"
ln -s "$(command -v python3)" "$url_update_root/bin/python3"
PATH="$url_update_root/bin" \
XDG_CONFIG_HOME="$url_update_root/config" \
    /usr/bin/bash "$repo_dir/private_dot_local/bin/executable_mihomo-subscription" \
    configure mxlsub https://example.com/private >/dev/null
python3 - "$url_update_root/config/mihomo/config.yaml" <<'PY'
import sys
from pathlib import Path

config = Path(sys.argv[1])
text = config.read_text()
assert 'url: "https://example.com/private"' in text
assert text.count("url: https://xxxx.yyy") == 1
assert "mixed-port: 10808" in text
assert "port: 10809" not in text and "socks-port:" not in text
assert "external-controller: 0.0.0.0:9090" in text
assert "secret: xxxx" in text and "mode: global" in text
assert "additional-prefix: '[mxlsub]'" in text
assert "additional-prefix: '[pokemon]'" in text
assert config.stat().st_mode & 0o777 == 0o600
PY

fake_codex="$test_root/fake-codex"
fake_pi_skills="$test_root/fake-pi-skills"
fake_manifest="$test_root/pi-skills.txt"
mkdir -p \
    "$fake_codex/skills/.system/imagegen" \
    "$fake_codex/skills/skill-creator" \
    "$fake_codex/plugins/cache/kami/kami/1.9.0/skills/kami" \
    "$fake_codex/plugins/cache/kami/kami/1.11.0/skills/kami"
touch \
    "$fake_codex/skills/.system/imagegen/SKILL.md" \
    "$fake_codex/skills/skill-creator/SKILL.md" \
    "$fake_codex/plugins/cache/kami/kami/1.9.0/skills/kami/SKILL.md" \
    "$fake_codex/plugins/cache/kami/kami/1.11.0/skills/kami/SKILL.md"
printf '%s\n' \
    'imagegen codex-system imagegen' \
    'skill-creator codex-user skill-creator' \
    'kami codex-plugin kami@kami' \
    > "$fake_manifest"
CODEX_HOME="$fake_codex" \
PI_SKILLS_TARGET_ROOT="$fake_pi_skills" \
PI_SKILLS_MANIFEST="$fake_manifest" \
    "$repo_dir/scripts/sync-pi-skills" >/dev/null
test "$(readlink "$fake_pi_skills/imagegen")" = \
    "$fake_codex/skills/.system/imagegen"
test "$(readlink "$fake_pi_skills/skill-creator")" = \
    "$fake_codex/skills/skill-creator"
test "$(readlink "$fake_pi_skills/kami")" = \
    "$fake_codex/plugins/cache/kami/kami/1.11.0/skills/kami"
rm "$fake_pi_skills/imagegen"
mkdir "$fake_pi_skills/imagegen"
touch "$fake_pi_skills/imagegen/local-work"
CODEX_HOME="$fake_codex" \
PI_SKILLS_TARGET_ROOT="$fake_pi_skills" \
PI_SKILLS_MANIFEST="$fake_manifest" \
    "$repo_dir/scripts/sync-pi-skills" >/dev/null 2>&1
test -f "$fake_pi_skills/imagegen/local-work"
CODEX_HOME="$fake_codex" \
PI_SKILLS_TARGET_ROOT="$fake_pi_skills" \
PI_SKILLS_MANIFEST="$fake_manifest" \
    "$repo_dir/scripts/sync-pi-skills" --replace >/dev/null
test "$(readlink "$fake_pi_skills/imagegen")" = \
    "$fake_codex/skills/.system/imagegen"

secret_repo="$test_root/secret-repo"
mkdir -p "$secret_repo/tests"
git -C "$secret_repo" init -q
cp "$repo_dir/tests/pre-commit" "$secret_repo/tests/pre-commit"
printf '%s\n' 'safe=true' > "$secret_repo/example.conf"
git -C "$secret_repo" add example.conf
git -C "$secret_repo" -c core.hooksPath=tests commit --dry-run >/dev/null 2>&1 || true
(cd "$secret_repo" && tests/pre-commit staged >/dev/null)
printf '%s%s\n' 'api_' 'key=not-a-real-test-secret' > "$secret_repo/leak.conf"
git -C "$secret_repo" add leak.conf
if (cd "$secret_repo" && tests/pre-commit staged >/dev/null 2>&1); then
    printf '%s\n' 'secret hook accepted a credential-shaped staged file' >&2
    exit 1
fi

destination="$test_root/home"
mkdir -p "$destination"
chezmoi --source "$repo_dir" --destination "$destination" apply --force

navi_path="$repo_dir/private_dot_local/private_share/navi/cheats"
navi_bin=$(mise which navi)
test "$("$navi_bin" --path "$navi_path" --print --query 'git 设置 nvim 为默认编辑器' --best-match)" = \
    'git config --global core.editor "nvim"'
test "$("$navi_bin" --path "$navi_path" --print --query 'rclone 当前目录 http 服务' --best-match)" = \
    'rclone serve http . --addr :8000'

for lua_file in "$repo_dir"/dot_config/nvim/init.lua "$repo_dir"/dot_config/nvim/lua/*.lua; do
    nvim --headless -u NONE "+lua assert(loadfile('$lua_file'))" '+qa'
done

printf '%s\n' 'dotfiles smoke test passed'
