# My zsh config
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
   
fi

# eval
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# source plugins
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/fsh/fast-syntax-highlighting.plugin.zsh
source $HOME/.zsh/zsh-completions/zsh-completions.plugin.zsh

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
alias cat='bat -pp --theme="Nord"'

