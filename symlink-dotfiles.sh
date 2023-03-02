#!/bin/sh

dotfiles="$HOME/dotfiles"
config="$HOME/.config"

# echo ""
# if [ -d "$dotfiles" ]; then
#     echo "Symlinking dotfiles from $dotfiles"
# else
#     echo "$dotfiles does not exist"
#     exit 1
# fi
#
# echo ""
# if [ -d "$config" ]; then
#     echo "Symlinking dotfiles to $config"
# else
#     echo "$config does not exist"
#     exit 1
# fi
#
link() {
    from="$1"
    to="$2"
    echo "Linking '$from' to '$to'"
    rm -f "$to"
    ln -s "$from" "$to"
}

# link "$dotconfig/nvim" "$config/nvim"


# for name in `ls home`; do
#     link "$dotfiles/home/$name" "$HOME/$name"
# done
link "$dotfiles/home/zshrc" "$HOME/.zshrc"
link "$dotfiles/home/ideavimrc" "$HOME/.ideavimrc"

for name in `ls config`; do
    link "$dotfiles/config/$name" "$config/$name"
done
