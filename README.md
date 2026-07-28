# Cross-platform development dotfiles

This repository is the reproducible source of truth for development tools and
portable user configuration on Arch Linux, macOS and other Linux
distributions. Chezmoi manages user files, Mise installs development tools,
and the platform package layer installs native applications and system
services.

| Platform | System package layer | Development tools | Mihomo service |
| --- | --- | --- | --- |
| Arch Linux | Pacman + Paru | Mise | systemd user unit |
| macOS | Homebrew | Mise | launchd user agent |
| Other Linux | Nix user profile | Mise | systemd user unit |

Mise is intentionally not used for system-integrated tools such as Mihomo.
Those stay in Pacman, Homebrew or Nix so their native binaries can be upgraded
without pretending they are language runtimes.

Desktop-session experiments are intentionally local. Window-manager, display
manager, input-method styling, bars, lock screens, notifications and wallpapers
are not tracked or installed by this repository.

Installation notes and personal tool observations live under [`notes/`](notes/).
They are versioned in Git but excluded from Chezmoi deployment.

## Install on Arch Linux

```bash
sudo pacman -S --needed git base-devel
git clone https://github.com/JulyFinal/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap --profile laptop-intel
```

Available profiles:

- `auto`: `laptop-intel` on Arch, `portable` elsewhere.
- `laptop-intel`: laptop power services, Intel microcode and graphics.
- `laptop-amd`: laptop power services, AMD microcode and graphics.
- `desktop`: no battery, backlight, laptop power or GPU-vendor packages.
- `portable`: no Arch hardware or desktop service assumptions.
- `laptop`: legacy alias for `laptop-intel`.

Preview without changing the machine:

```bash
./bootstrap --profile laptop-intel --dry-run
```

## Install on macOS

Install the Xcode Command Line Tools and Homebrew first:

```bash
xcode-select --install
```

Then clone and apply the portable profile:

```bash
git clone https://github.com/JulyFinal/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap --profile portable
```

The bootstrap runs `brew update`, installs or upgrades the formulae in
[`packages/brew-common.txt`](packages/brew-common.txt), installs or upgrades
the casks in [`packages/brew-cask.txt`](packages/brew-cask.txt), applies only
the macOS-compatible Chezmoi targets, and loads the Mihomo LaunchAgent.

## Install on other Linux distributions

Install Git and Nix first, then run:

```bash
git clone https://github.com/JulyFinal/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap --profile portable
```

The bootstrap installs or upgrades the system tools listed in
[`packages/nix-common.txt`](packages/nix-common.txt) in the user Nix profile.
It does not modify the host distribution's package database. A working
systemd user session is required for the managed Mihomo service.

Preview any supported platform without installing packages:

```bash
./bootstrap --dry-run --platform arch
./bootstrap --dry-run --platform macos
./bootstrap --dry-run --platform linux
```

## Daily workflow

```bash
cd ~/dotfiles
git pull --ff-only
chezmoi diff
chezmoi apply
chezmoi verify
./doctor
```

- `chezmoi diff` previews destination changes.
- `chezmoi apply` deploys the repository state.
- `chezmoi verify` exits non-zero when a managed file has drifted.
- `./doctor` verifies editors, services, MCP and proxy runtime.
- `./tests/smoke.sh` validates the repository without sudo.

## Shared Pi skills

Skill implementations are not vendored into this repository. The desired
links are declared in [`packages/pi-skills.txt`](packages/pi-skills.txt), and
[`scripts/sync-pi-skills`](scripts/sync-pi-skills) links the current Codex
system, user and plugin-cache versions into `~/.pi/agent/skills/`.

The bootstrap runs the linker after `mise install`. Run it directly after a
Codex plugin upgrade:

```bash
./scripts/sync-pi-skills
```

If a real directory already occupies a target, the script leaves it untouched
and reports `SKIP`. Migrate those directories to managed links explicitly:

```bash
./scripts/sync-pi-skills --replace
```

`--replace` only removes the named skill targets under
`~/.pi/agent/skills/`; their Codex source remains intact.

Lightpanda MCP configuration is rendered only when `docker` is already
available. Docker itself is intentionally not installed by this repository;
daemon or Docker Desktop ownership remains a per-machine decision.

## Add and edit files

Edit a managed file through Chezmoi:

```bash
chezmoi edit ~/.config/kitty/kitty.conf
chezmoi diff
chezmoi apply
```

Import a file that was edited in place:

```bash
chezmoi add ~/.config/kitty/kitty.conf
```

Add a new application configuration or home file:

```bash
chezmoi add ~/.config/example/config.toml
chezmoi add ~/.gitconfig
chezmoi add ~/.local/bin/my-script
```

Use a template when a file contains a home path, username or profile-specific
section:

```bash
chezmoi add --template ~/.config/example/config.toml
```

Useful template values:

```text
{{ .chezmoi.homeDir }}
{{ .chezmoi.username }}
```

Chezmoi source naming maps to destination behavior:

| Source name | Destination behavior |
| --- | --- |
| `dot_config/foo` | `~/.config/foo` |
| `dot_zshrc` | `~/.zshrc` |
| `private_foo` | private permissions |
| `executable_foo` | executable permissions |
| `foo.tmpl` | rendered as a template |

Run `git status` and inspect the diff before committing an imported file.

## Remove, repair and roll back

Stop managing a file while leaving the destination in place:

```bash
chezmoi forget ~/.config/example/config.toml
```

Discard a destination-only edit and restore the repository version:

```bash
chezmoi apply ~/.config/kitty/kitty.conf
```

Restore a historical source file, then deploy it:

```bash
git restore --source=<commit> -- dot_config/kitty/kitty.conf
chezmoi apply ~/.config/kitty/kitty.conf
```

Roll back a whole commit without rewriting history:

```bash
git revert <commit>
chezmoi apply
./doctor
```

General repair sequence:

```bash
chezmoi doctor
chezmoi diff
chezmoi apply --force
chezmoi verify
./doctor
```

`--force` overwrites destination conflicts, so always inspect `chezmoi diff`
first. Historical layouts remain available through Git history and tags rather
than being duplicated under an `archive/` directory.

## Managed and excluded state

Managed state includes Kitty, Neovim, Zed, shell tools, development tool
versions, portable package manifests and the local proxy service. Linux-only
systemd, Vicinae and desktop files are excluded automatically on macOS;
the launchd agent is excluded on Linux.

Do not add browser profiles, proxy subscriptions, `gh/hosts.yml`, pairing
keys, histories, tokens, passwords, private keys, caches or container
filesystems. Restore secrets, desktop-session configuration and device pairing
manually after bootstrap.

## Local proxy

The platform Mihomo user service loads the private subscription provider and
exposes a single mixed HTTP/SOCKS endpoint on `127.0.0.1:10808`. Linux uses
`mihomo.service`; macOS uses `io.github.metacubex.mihomo`. Both are controlled
through the same commands:

```bash
proxyctl status
proxyctl test
proxyctl restart
proxyctl logs
```

Update or verify the private subscription with:

```bash
mihomo-subscription configure
mihomo-subscription test
```

The private `~/.config/mihomo/config.yaml` is generated from the tracked
example and is not managed by Chezmoi or Git. Retired proxy clients are not
installed by the bootstrap.

The `work` OpenVPN profile is imported into Mihomo as a private file provider;
NetworkManager does not need to activate it. The server pushes `comp-lzo no`,
which OpenVPN implements as uncompressed stub framing. Mihomo 1.19.29 omits
that frame for `no`, so the generated provider uses `comp-lzo: "yes"` to emit
the compatible uncompressed frame. Configure and verify it with:

```bash
mihomo-openvpn configure work
mihomo-openvpn test
```

The generated provider contains the decrypted client key, is mode `0600`, and
lives only under `~/.local/share/mihomo/providers/`; it is never tracked by
Chezmoi. Traffic for `192.168.168.0/24` selects the `WORK` group, while all
other traffic continues to use the normal subscription `PROXY` group.

### Standalone Ubuntu/Debian installation

For a machine that should use the official system-wide Mihomo DEB instead of
the portable Nix/user-service path:

```bash
install-mihomo-ubuntu
```

The installer selects the current official release for amd64 or arm64 and
verifies the SHA-256 published by GitHub. The private subscription still needs
to be restored separately in `/etc/mihomo/config.yaml`.
