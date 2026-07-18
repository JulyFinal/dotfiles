# Arch + Niri dotfiles

This repository is the reproducible source of truth for the current Arch Linux
desktop. Chezmoi manages user files, Pacman and Paru install system packages,
Mise installs development tools, and the bootstrap enables required services.

## Install

```bash
sudo pacman -S --needed git base-devel
git clone https://github.com/JulyFinal/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap --profile laptop-intel
```

Available profiles:

- `laptop-intel`: laptop UI, power services, Intel microcode and graphics.
- `laptop-amd`: laptop UI, power services, AMD microcode and graphics.
- `desktop`: no battery, backlight, laptop power or GPU-vendor packages.
- `laptop`: legacy alias for `laptop-intel`.

Preview without changing the machine:

```bash
./bootstrap --profile laptop-intel --dry-run
```

Pass `--skip-deepin` to omit the Deepin/WeCom container.

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
- `./doctor` verifies the desktop, editor, services, MCP and proxy runtime.
- `./tests/smoke.sh` validates both display profiles without sudo.

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
{{ .profile }}
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
first. The tag `pre-chezmoi-20260718` is reference material for the legacy
layout; do not run its old destructive symlink script.

## Managed and excluded state

Managed state includes Niri, Waybar, Kitty, Mako, Hyprlock, Fcitx5, GTK,
Vicinae, Neovim, shell tools, package manifests, services, Distrobox/WeCom and
v2rayN autostart.

Do not add browser profiles, proxy subscriptions, `gh/hosts.yml`, KDE Connect
pairing keys, histories, tokens, passwords, private keys, caches or container
filesystems. Restore secrets and device pairing manually after bootstrap.
