# Personal Environment Kit

This repository is a direct, disposable-machine-friendly configuration center.
It deliberately separates configuration deployment, networked installation,
private local data and operating-system setup.

The default path needs only a POSIX shell and Git:

```sh
git clone https://github.com/JulyFinal/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup
```

`setup` presents an interactive multi-select installer. The usual temporary
machine choice is **Core configurations**. Software installation is a separate,
explicit selection.

## What lives where

```text
home/                    core files; mirrors $HOME exactly
personal/home/           optional personal files; also mirrors $HOME
overlays/<platform>/     Linux, Arch or macOS overrides
private/examples/        safe examples and schemas
private/templates/home/  optional generated files
private.local/           ignored local secrets and complete private files
manifests/                external content declarations
recipes/                  commands worth keeping, not deployed configuration
scripts/                  explicit installers and helpers
systems/arch/             isolated Arch installation
deploy.conf               copy/template exceptions; everything else is linked
```

For example:

```text
home/.config/mise/config.toml
```

always maps to:

```text
~/.config/mise/config.toml
```

There is no encoded `dot_`, `private_` or source-state naming.

## Scopes

### Core

Core is intentionally small:

- Zsh and Bash entrypoints
- Tmux
- Navi personal cheats
- Mise configuration
- Starship
- portable shell paths

### Personal

Personal currently contains Neovim, Helix, Kitty, Yazi, Atuin, Tealdeer,
Vicinae and local agent configuration.

### Private

Private state is optional and never blocks core or personal deployment:

```sh
mkdir -p private.local/home private.local
cp private/examples/secrets.toml private.local/secrets.toml
```

Files below `private.local/home/` mirror `$HOME` and are copied with private
permissions. This directory is ignored by Git and can be moved manually through
the user's chosen storage.

Templates support:

```text
@HOME@
@SECRET:mihomo.subscription_url@
@IF_COMMAND docker@ ... @END@
```

Secret values come from `private.local/secrets.toml`. Secret-bearing templates
require Taplo, which is installed by the core Mise configuration.

## Human interface

Use the interactive installer:

```sh
./setup
```

It can deploy any combination of core, personal and private files, explicitly
install tools, and run diagnostics.

Before changing the destination it displays the complete plan and unified diffs.
After one confirmation it applies the repository version directly. It does not
create backups.

## Scriptable interface

The backend remains available for automation and debugging:

```sh
./dotfiles plan core personal
./dotfiles apply core personal
./dotfiles apply core --yes
./dotfiles install core
./dotfiles doctor core personal
./dotfiles explain ~/.zshrc
```

Hard behavior boundaries:

- `apply` never accesses the network.
- `install` is the only networked action.
- Existing destination files are replaced after the plan is confirmed.
- Deleted repository files are not tracked or cleaned from old machines.
- Platform detection applies Linux, Arch or macOS overlays automatically.
- `personal` and `private` are never inferred from hostname.

Set `DOTFILES_HOME` and `DOTFILES_PLATFORM` to preview against an isolated home:

```sh
DOTFILES_HOME=/tmp/test-home DOTFILES_PLATFORM=macos \
    ./dotfiles plan core personal
```

## Link, copy and template behavior

Files are linked by default, so editing either the repository or the deployed
path edits the same source.

[`deploy.conf`](deploy.conf) lists exceptions. Shell entrypoints such as
`~/.zshrc` are copied because third-party installers frequently append to them.
Their real repository-owned configuration lives under
`~/.config/shell/`. Reapplying shows a diff and recreates the thin entrypoint.

Generated agent configurations use `@HOME@` templates and are written with mode
`0600`.

## Installing tools

Core installation uses the official Mise installer when Mise is missing, then
installs the tools declared in
[`home/.config/mise/config.toml`](home/.config/mise/config.toml):

```sh
./dotfiles install core
```

Tool declarations intentionally use `latest`. External Git content listed in
`manifests/latest-git.conf` is cloned or fast-forwarded by:

```sh
./dotfiles install personal
```

Agent skills are declared visually in
[`manifests/agent-skills.yaml`](manifests/agent-skills.yaml). Synchronize them
for Codex, Claude Code and Pi with:

```sh
mise run skills-sync
```

The skills CLI keeps one canonical copy under `~/.agents/skills` and links that
copy into each agent. The task re-adds every configured source so subpath
packages such as Kami also track the latest version. Preview without changing
anything with `mise run skills-sync -- --dry-run`.

See [`recipes/mise.md`](recipes/mise.md) for the direct commands.

## Arch installation

Arch system installation is deliberately outside the dotfiles workflow:

```sh
systems/arch/install --profile laptop-intel --dry-run
systems/arch/install --profile desktop
```

`setup` and `dotfiles apply` never call this installer.

## Safety and verification

```sh
./tests/smoke.sh
./tests/pre-commit worktree
```

The pre-commit scanner rejects credential-shaped content. Put real private data
under ignored `private.local/`, never under `home/` or `personal/home/`.
