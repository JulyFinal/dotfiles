# Arch + Niri dotfiles

This repository is the reproducible source of truth for the current Arch Linux
desktop. Chezmoi manages user files, Pacman and Paru install system packages,
Mise installs development tools, and the bootstrap enables required services.

## Fresh installation

```bash
sudo pacman -S --needed git base-devel
git clone https://github.com/JulyFinal/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap --profile laptop
```

For a desktop without laptop-specific power, backlight and Intel graphics
packages:

```bash
./bootstrap --profile desktop
```

Preview all declared work without changing the machine:

```bash
./bootstrap --profile laptop --dry-run
```

Use `--skip-deepin` to omit the Deepin/WeCom container.

## Daily use

```bash
chezmoi diff
chezmoi apply
./doctor
```

Edit deployed files normally, then import the changes with `chezmoi add` or use
`chezmoi edit`. The repository source directory is `~/dotfiles`.

## Managed state

- Niri, Waybar, Kitty, Mako, Hyprlock, Fcitx5, GTK and Vicinae configuration.
- Shell, editors, Mise tools and personal command palette.
- Arch official and AUR package manifests.
- greetd and enabled system/user services.
- Deepin Distrobox definition and the WeCom launcher workaround.
- v2rayN XDG autostart with start-hidden and close-to-tray behavior.

Browser profiles, proxy subscriptions, device pairing keys, histories and
container filesystems are deliberately excluded. Restore subscription secrets
manually after bootstrap.

## Rollback

The tag `pre-chezmoi-20260718` contains the last symlink-managed layout. The
legacy files are also preserved under `archive/pre-chezmoi` for reference but
are ignored by Chezmoi.
