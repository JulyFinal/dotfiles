# final's dotfiles

## fist step

```bash
# git config --global url."https://ghproxy.com/https://github.com".insteadOf "https://github.com"
git clone https://github.com/JulyFinal/dotfiles.git
# git clone git@github.com:JulyFinal/dotfiles.git
cd dotfiles && ./symlink-dotfiles.sh
```

## fonts
```
# mkdir -p ~/.local/share/fonts
# wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/FiraMono.zip
# unzip FiraMono.zip -d FiraMono
# mv FiraMono ~/.local/share/fonts
# fc-cache -fv
```


## install base pkg
`# sudo pacman -S --needed base-devel # for pacman`

`fd ripgrep fzf sd openssl xsel zip unzip zlib xz neovim lazygit bat bottom tealdeer zoxide direnv atuin`

## zsh

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
```


## nix

`sh <(curl -L https://nixos.org/nix/install) --no-daemon`  # install nix

`# nix-channel --add https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixpkgs-unstable nixpkgs`
`# nix-channel --update`


## rust
`curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh` # install rustup

`# rustup default stable`

## python
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh

uv tool install ruff
uv tool install basedpyright
```

## tools
`nix-env -iA nixpkgs.`

## lsp
```bash
lua-language-server StyLua shfmt taplo alejandra deno
cargo install --git https://github.com/estin/simple-completion-language-server.git # for helix
# cargo install harper-ls --locked # English grammar checker
```


## git

```bash
git config user.email "julyfinal@outlook.com"
git config user.name "final"
```
