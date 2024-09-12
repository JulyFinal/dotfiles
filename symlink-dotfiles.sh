#!/bin/bash

dotfiles="$HOME/dotfiles"
config="$HOME/.config"
# 默认 shell 是 bash
current_shell="bash"
# 如果传入了参数，则使用传入的 shell
if [ "$#" -gt 0 ]; then
    case "$1" in
        bash|zsh)
            current_shell="$1"
            ;;
        *)
            echo "Unknown shell: $1"
            echo "Usage: $0 [bash|zsh]"
            exit 1
            ;;
    esac
fi

if [ -d "$config" ]; then
    echo "Symlinking dotfiles to $config"
else
    echo "$config does not exist"
    exit 1
fi

link() {
    from="$1"
    to="$2"
    echo "Linking '$from' to '$to'"
    rm -rf "$to"
    ln -s "$from" "$to"
}


# 根据指定的 shell 类型执行配置操作
case "$current_shell" in
  bash)
    echo "Current shell is bash"
    if [ ! -f "$HOME/.profile" ]; then
      touch "$HOME/.profile"
    fi
    echo "source $dotfiles/home/custom.sh" >> "$HOME/.profile"
    ;;
  zsh)
    echo "Current shell is zsh"
    if [ ! -f "$HOME/.zshrc" ]; then
      touch "$HOME/.zshrc"
    fi
    echo "source $dotfiles/home/custom.sh" >> "$HOME/.zshrc"
    ;;
esac


link "$dotfiles/home/tmux.conf" "$HOME/.tmux.conf"
# link "$dotfiles/home/emacs.d" "$HOME/.emacs.d"

for name in `ls config`; do
    link "$dotfiles/config/$name" "$config/$name"
done
