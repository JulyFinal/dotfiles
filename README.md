# Personal Environment Kit

This repository is a small, direct configuration center for disposable
machines. The source tree is intentionally visible; a single YAML menu maps
those sources to the hidden paths applications expect under `$HOME`.

The default path needs only a POSIX shell and Git:

```sh
git clone https://github.com/JulyFinal/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup
```

`setup` presents a short interactive menu. On a temporary machine, selecting
**Core configurations** is enough; personal files, tool installation, and
diagnostics remain separate choices.

## What lives where

```text
config/                   visible configuration sources
config/README.md          source-tree guide
manifests/files.yaml      source, target, method, mode, and platform menu
manifests/agent-skills.yaml
                          external skills and their agent targets
examples/                 safe non-secret examples
secrets.example.toml      copyable secret-file shape; secrets.toml is ignored
minijinja.toml            repository-local template defaults
scripts/install-mise      standalone Mise installer
systems/                  Arch, Linux, and macOS package/install notes
recipes/                  commands worth keeping, not deployed configuration
docs/                     maintenance and contributor notes
tests/                    smoke test and secret scanner
```

The repository source path does not have to match the destination path. For
example, `config/mise/config.toml` maps to
`~/.config/mise/config.toml`, while `config/agents/codex/config.toml.j2` maps
to `~/.codex/config.toml`. See [`config/README.md`](config/README.md) for the
visible layout and [`manifests/files.yaml`](manifests/files.yaml) for the
complete mapping.

## Scopes

The deployment menu currently has two groups:

- **Core**: shell entrypoints, Tmux, Navi cheats, Mise, Starship, and portable
  shell paths.
- **Personal**: Neovim, Helix, Kitty, Yazi, Atuin, Tealdeer, Vicinae, and the
  local agent configuration.

The group is only a selection menu. The exact files and behavior live in the
manifest, so adding or removing one file does not require changing the shell
engine.

## Secrets and templates

Real secret values stay in the ignored repository-root `secrets.toml`:

```sh
cp secrets.example.toml secrets.toml
chmod 600 secrets.toml
```

The file is never linked into `$HOME`. A `.j2` source is rendered only when its
manifest entry says `method: template`; all other files are linked or copied
directly. MiniJinja receives the root TOML file as template data, so a template
can use values such as:

```jinja
{{ mihomo.subscription_url }}
{{ home }}
{% if docker_available %} ... {% endif %}
```

On a temporary machine, apply only `core` and no secret file is needed. If the
secret file was moved elsewhere, point at it explicitly:

```sh
DOTFILES_SECRETS_FILE=/path/to/secrets.toml \
    ./dotfiles apply personal
```

## Human interface

Use the interactive installer:

```sh
./setup
```

It can select core or personal configuration, install the Mise tool set, and
run diagnostics. Before changing the destination it prints the complete plan
and unified diffs. After confirmation it applies the repository version
directly; it does not create backups.

## Scriptable interface

The public backend is intentionally small:

```sh
./dotfiles plan core personal
./dotfiles apply core personal
./dotfiles apply core --yes
./dotfiles install core
./dotfiles doctor core personal
./dotfiles explain ~/.zshrc
```

Useful boundaries:

- `apply` never accesses the network.
- `install` is the only networked action.
- Existing destination files are replaced only after the plan is shown and
  confirmed.
- Deleted repository files are not removed from old machines automatically.
- `platforms` in the manifest controls platform-specific entries; there are no
  separate overlay trees.

Preview against an isolated home:

```sh
DOTFILES_HOME=/tmp/test-home DOTFILES_PLATFORM=macos \
    ./dotfiles plan core personal
```

The manifest parser intentionally uses a small, flat YAML subset so the core
workflow still works on a fresh POSIX machine. `yq`, when available, validates
the manifest in the smoke test; it is not required to apply core files.

## Link, copy, and template behavior

The `method` field in [`manifests/files.yaml`](manifests/files.yaml) is the
source of truth:

- `link` creates an absolute symlink to the repository source.
- `copy` creates an independent file and reapplies the declared mode.
- `template` renders a `.j2` source through MiniJinja and applies the declared
  mode.

Shell entrypoints such as `~/.zshrc` are copied because installers often append
to them. Their repository-owned configuration lives in `config/shell/`.
Reapplying shows a diff and recreates the thin entrypoint.

## Installing tools

Core installation uses the official Mise installer when Mise is missing, then
installs the tools declared by
[`config/mise/config.toml`](config/mise/config.toml):

```sh
./dotfiles install core
```

Tool declarations intentionally use `latest`. Agent skills are declared in
[`manifests/agent-skills.yaml`](manifests/agent-skills.yaml). Synchronize the
shared copy for Codex, Claude Code, and Pi with:

```sh
mise run skills-sync
```

Preview without changing anything with:

```sh
mise run skills-sync -- --dry-run
```

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

The pre-commit scanner rejects credential-shaped content. Put real secret
values in the ignored root `secrets.toml`, and keep non-secret examples under
`examples/`.
