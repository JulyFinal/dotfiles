
# ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# mkdir -p "$(dirname $ZINIT_HOME)"
# git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

# zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

source "${ZINIT_HOME}/zinit.zsh"

zinit light spaceship-prompt/spaceship-prompt

zinit wait lucid for \
    light-mode \
  zsh-users/zsh-autosuggestions \
    light-mode \
  zsh-users/zsh-completions \
    light-mode \
  zdharma-continuum/fast-syntax-highlighting \

# zsh config
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e


alias vi="nvim"
alias pc4="proxychains4"
alias setproxy="export ALL_PROXY=socks5://127.0.0.1:7890; echo 'SET PROXY SUCCESS!!!'"
alias unsetproxy="unset ALL_PROXY; echo 'UNSET PROXY SUCCESS!!!'"
alias av="source .venv/bin/activate"
alias tree="lsd --tree"


# eval
eval "$(zoxide init zsh)"

# set PATH so it includes user's private ~/.local/bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/miniforge3/bin" ] ; then
    PATH="$HOME/miniforge3/bin:$PATH"
fi

