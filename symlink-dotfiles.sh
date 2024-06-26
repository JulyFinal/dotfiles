#!/bin/sh

dotfiles="$HOME/dotfiles"
config="$HOME/.config"

echo ""
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

if [ ! -f "$HOME/.zshrc" ]; then
    touch $HOME/.zshrc
fi
echo "source $dotfiles/home/zshrc" >> $HOME/.zshrc

link "$dotfiles/home/tmux.conf" "$HOME/.tmux.conf"
# link "$dotfiles/home/emacs.d" "$HOME/.emacs.d"

for name in `ls config`; do
    link "$dotfiles/config/$name" "$config/$name"
done
