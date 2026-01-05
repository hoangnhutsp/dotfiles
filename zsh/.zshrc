export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias reload="source ~/.zshrc"


alias vim='nvim'
alias v='nvim'
alias vi='nvim'
alias slotty_cleanlog='cd "/home/tranghoangnhut/go/src/slotty" && find . -type f -name "*.log" -print -delete'


# fzf

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source <(fzf --zsh)
alias f=fzf
alias fp='fzf --preview="bat --color=always {}"'
alias fv='nvim $(fzf -m --preview="bat --color=always {}")'

alias bootstraps='~/dotfiles/scripts/tmux-init.sh'

export GOBIN=$HOME/go/bin
export GOPATH=$HOME/go
export GOROOT='/usr/local/go'
export PATH=$PATH:$GOROOT/bin:$GOBIN
export GOPROXY=https://proxy.golang.org,direct
export GOMODULE=1

export PATH=~/.npm-global/bin:$PATH
export PATH=~/.local/bin:$PATH

eval "$(zoxide init zsh)"


