if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.local/share/mise/shims" ]; then
    PATH="$HOME/.local/share/mise/shims:$PATH"
fi
if [ -d "$HOME/.nix-profile/bin" ]; then
    PATH="$HOME/.nix-profile/bin:$PATH"
fi
export PATH
