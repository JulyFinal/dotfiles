export GOPATH="$HOME/.local/share/go"
export GOBIN="$HOME/.local/bin"

export GO111MODULE=on
export GOPROXY=https://goproxy.cn
export LANGUAGE=en

# Reloading the shell must not keep growing PATH.
for shell_bin in "$HOME/.local/bin" "$HOME/.local/share/mise/shims" "$HOME/.nix-profile/bin"; do
    [ -d "$shell_bin" ] || continue
    case ":$PATH:" in
    *":$shell_bin:"*) ;;
    *) PATH="$shell_bin:$PATH" ;;
    esac
done
unset shell_bin
export PATH

# Shared commands and aliases
if [ -f "$HOME/.config/shell/aliases.sh" ]; then
    . "$HOME/.config/shell/aliases.sh"
fi
