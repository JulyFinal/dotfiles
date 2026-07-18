#!/bin/bash

dotfiles="$HOME/dotfiles"
config="$HOME/.config"

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
echo "Current shell is zsh"
if [ -f "$HOME/.zshrc" ]; then
  rm -rf "$HOME/.zshrc"
fi


for name in `ls home`; do
    link "$dotfiles/home/$name" "$HOME/.$name"
done

for name in `ls config`; do
    link "$dotfiles/config/$name" "$config/$name"
done
