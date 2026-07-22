#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
test_root=$(mktemp -d /tmp/dotfiles-smoke.XXXXXX)
trap 'rm -rf -- "$test_root"' EXIT

bash -n "$repo_dir/bootstrap" "$repo_dir/doctor"
PYTHONPYCACHEPREFIX="$test_root/pycache" python3 -m py_compile "$repo_dir/tests/pre-commit"
"$repo_dir/tests/pre-commit" worktree
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
    tomllib.loads(path.read_text())
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
assert "proxy-core.service" not in user_services and "v2rayn" not in aur_packages
retired_tools = {
    "firefox", "freerdp", "gtk-vnc", "helix", "imagemagick",
    "libvncserver", "remmina", "sshfs",
}
assert retired_tools.isdisjoint(pacman_packages)
assert "xray" not in aur_packages
assert "rclone" not in (root / "dot_config/mise/config.toml").read_text().splitlines()
assert "rclone-koofr.service" not in user_services
assert not (root / "dot_config/autostart/v2rayN.desktop.tmpl").exists()
assert not (root / "private_dot_local/bin/executable_v2rayn-background").exists()
mihomo_example = (root / "dot_config/mihomo/config.yaml.example").read_text()
mihomo_service = (root / "dot_config/systemd/user/mihomo.service").read_text()
mihomo_subscription = (root / "private_dot_local/bin/executable_mihomo-subscription").read_text()
mihomo_openvpn = (root / "private_dot_local/bin/executable_mihomo-openvpn").read_text()
mihomo_ubuntu = (root / "private_dot_local/bin/executable_install-mihomo-ubuntu").read_text()
assert "__SUBSCRIPTION_URL__" in mihomo_example
assert "enhanced-mode: fake-ip" in mihomo_example and "proxy-server-nameserver" in mihomo_example
assert "config.yaml" in mihomo_service and "mihomo -t" in mihomo_service
assert "metacubexd" not in mihomo_service.lower()
assert "10809" in mihomo_subscription and "providers/proxies/subscription" in mihomo_subscription
assert 'group["now"] != "COMPATIBLE"' in mihomo_subscription
assert "work-openvpn" in mihomo_example and "192.168.168.0/24,WORK" in mihomo_example
assert '"comp-lzo": "yes"' in mihomo_openvpn and '"auth": "SHA1"' in mihomo_openvpn
assert "nmcli connection up" not in mihomo_openvpn
assert "mihomo-linux-amd64-v1-" in mihomo_ubuntu
assert "sha256sum --check" in mihomo_ubuntu and "metacubexd" not in mihomo_ubuntu.lower()
assert "systemctl enable --now mihomo.service" in mihomo_ubuntu
desktop_paths = [
    "archive", "dot_config/greetd", "dot_config/hypr", "dot_config/mako",
    "dot_config/niri", "dot_config/private_fcitx5", "dot_config/quickshell",
    "dot_config/swaylock", "dot_config/waybar",
]
assert all(not (root / path).exists() for path in desktop_paths)
assert not (root / "dot_config/systemd/user/rclone-koofr.service").exists()
assert not (root / "private_dot_local/bin/executable_rdp-copy-image").exists()
gitignore = (root / ".gitignore").read_text()
assert "dot_config/mihomo/config.yaml" in gitignore and "*.ovpn" in gitignore
bootstrap = (root / "bootstrap").read_text()
assert "config core.hooksPath tests" in bootstrap
doctor = (root / "doctor").read_text()
assert 'tests/pre-commit" worktree' in doctor and 'tests/pre-commit" staged' in doctor
PY

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

for lua_file in "$repo_dir"/dot_config/nvim/init.lua "$repo_dir"/dot_config/nvim/lua/*.lua; do
    nvim --headless -u NONE "+lua assert(loadfile('$lua_file'))" '+qa'
done

printf '%s\n' 'dotfiles smoke test passed'
