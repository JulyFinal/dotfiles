if [ -e /home/final/.nix-profile/etc/profile.d/nix.sh ]; then . /home/final/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
if [ -d "$HOME/.local/bin" ]; then PATH="$HOME/.local/bin:$PATH"; fi
if [ -d "$HOME/.cargo/bin" ]; then PATH="$HOME/.cargo/bin:$PATH"; fi
if [ -d "$HOME/.cargo/bin" ]; then source "$HOME/.cargo/env"; fi

# eval
if [ -n "$BASH_VERSION" ]; then
  eval "$(uv generate-shell-completion bash)"
  eval "$(starship init bash)"
  eval "$(zoxide init bash)"
  eval "$(direnv hook bash)"
  # ble config
  [[ $- == *i* ]] && source "$(blesh-share)"/ble.sh --noattach
elif [ -n "$ZSH_VERSION" ]; then
  eval "$(uv generate-shell-completion zsh)"
  eval "$(starship init zsh)"
  eval "$(zoxide init zsh)"
  eval "$(direnv hook zsh)"
else
  echo "must be zsh or bash"
fi

# custom alias
alias vi="nvim"
alias at="tmux a -t 0"

# PROXY
alias setproxy="export ALL_PROXY=socks5://finalserver:7890; echo 'SET PROXY SUCCESS!!!'"
alias setproxylocal="export ALL_PROXY=socks5://127.0.0.1:7890; echo 'SET PROXY SUCCESS!!!'"
alias unsetproxy="unset ALL_PROXY; echo 'UNSET PROXY SUCCESS!!!'"

## python
alias av="source .venv/bin/activate"
alias pp="export PYTHONPATH=$(pwd)"
alias pipcn='uv pip install -i https://pypi.tuna.tsinghua.edu.cn/simple'

# linux command
alias ls="ls --color=auto"
alias ll="ls -lh --color=auto"
alias la="ls -alh --color=auto"
alias h5="head -n 5"
alias h10="head -n 10"
alias du="du -sh"
alias w="watch -n"
alias tf="tail -f"
alias disksize="lsblk --json | jq -c '.blockdevices[] | [.name,.size]'"
alias uvt="uv tool"
alias rebash="source ~/.profile"
alias rezsh="source ~/.zshrc"

# >>> git command >>>
alias gitforceinit="git fetch --all && git reset --hard origin/master && git pull"

# browser in terminal
alias browser="docker run --rm -ti fathyb/carbonyl"

if command -v fzf >/dev/null 2>&1; then
  # fzf theme
  export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
  # change search
  export FZF_DEFAULT_COMMAND='rg --files --hidden'

  alias pv="fzf --preview 'bat --color \"always\" {}'"

fi


if command -v bat >/dev/null 2>&1; then
  alias cat='bat -pp --theme="Nord"'
  alias tailf='f() { tail -f "$1" | bat --paging=never -l log; unset -f f; }; f'
fi

## 解压缩
ex() {
  if [ -f $1 ]; then
    case $1 in
    *.tar.bz2) tar xjf $1 ;;
    *.tar.gz) tar xzf $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar x $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xf $1 ;;
    *.tbz2) tar xjf $1 ;;
    *.tgz) tar xzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *) echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

## diff
gdiff() { git diff --name-only --relative --diff-filter=d | xargs bat --diff; }

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion


if [ -n "$BASH_VERSION" ]; then
  [[ ! ${BLE_VERSION-} ]] || ble-attach
fi
