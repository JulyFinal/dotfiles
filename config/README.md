# Configuration sources

This directory is intentionally visible. It contains the repository sources;
the destination names in `$HOME` may still begin with a dot because that is
what the applications expect.

The deployment mapping is defined in [`../manifests/files.yaml`](../manifests/files.yaml):

- `shell/entrypoints/` contains files copied to `.bashrc`, `.profile`,
  `.tmux.conf`, and `.zshrc`.
- `shell/` contains the shared shell configuration linked below
  `.config/shell/`.
- `agents/` contains Codex MCP and Pi templates/settings. Agent merge entries
  only update repository-owned fields; local model, trust, Feishu, and other
  personalized values remain in place.
- `mise/`, `nvim/`, `helix/`, `kitty/`, `yazi/`, and the other top-level
  directories contain application configuration.
- `navi/` contains the cheat file deployed below `.local/share/navi/`.

Edit these source files directly. Use `./dotfiles explain PATH` when the
destination or deployment method is unclear.
