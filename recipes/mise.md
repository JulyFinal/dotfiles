# Mise

The executable installer uses the official `https://mise.run` endpoint and
installs Mise into `~/.local/bin/mise`.

Run it directly:

```sh
./scripts/install-mise
```

Then install every tool declared by the repository:

```sh
MISE_CONFIG_FILE="$PWD/config/mise/config.toml" mise install
```

This also installs `minijinja-cli`, which the template deployment path uses to
render agent configuration files. Secret values are supplied from
the ignored repository-root `secrets.toml` when that file exists.

Configuration deployment and software installation are intentionally separate:

```sh
./dotfiles apply core
./dotfiles install core
```

After core configuration and tools are present, synchronize the shared agent
skills declared in `manifests/agent-skills.yaml`:

```sh
mise run skills-sync
```

Preview the resolved sources and target agents first:

```sh
mise run skills-sync -- --dry-run
```
