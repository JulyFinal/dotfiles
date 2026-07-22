# Arch development dotfiles

This repository is the reproducible source of truth for development tools and
portable user configuration on Arch Linux. Chezmoi manages user files, Pacman
and Paru install reusable packages, Mise installs development tools, and the
bootstrap enables required background services.

Desktop-session experiments are intentionally local. Window-manager, display
manager, input-method styling, bars, lock screens, notifications and wallpapers
are not tracked or installed by this repository.

Installation notes and personal tool observations live under [`notes/`](notes/).
They are versioned in Git but excluded from Chezmoi deployment.

## Install

```bash
sudo pacman -S --needed git base-devel
git clone https://github.com/JulyFinal/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap --profile laptop-intel
```

Available profiles:

- `laptop-intel`: laptop power services, Intel microcode and graphics.
- `laptop-amd`: laptop power services, AMD microcode and graphics.
- `desktop`: no battery, backlight, laptop power or GPU-vendor packages.
- `laptop`: legacy alias for `laptop-intel`.

Preview without changing the machine:

```bash
./bootstrap --profile laptop-intel --dry-run
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

Managed state includes Kitty, Vicinae, Neovim, Zed, shell tools, development
tool versions, portable package manifests and the local proxy service.

Do not add browser profiles, proxy subscriptions, `gh/hosts.yml`, pairing
keys, histories, tokens, passwords, private keys, caches or container
filesystems. Restore secrets, desktop-session configuration and device pairing
manually after bootstrap.

## Local proxy

`mihomo.service` loads the private subscription provider and exposes a single
mixed HTTP/SOCKS endpoint on `127.0.0.1:10808`. Use:

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

### Ubuntu/Debian

Install the official Mihomo DEB and packaged systemd service:

```bash
install-mihomo-ubuntu
```

The installer selects the current official release for amd64 or arm64 and
verifies the SHA-256 published by GitHub. The private subscription still needs
to be restored separately in `/etc/mihomo/config.yaml`.
