export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

alias reload="source ~/.zshrc"


alias vim='nvim'
alias v='nvim'
alias vi='nvim'
alias python='python3'
alias k='kubectl'
alias pip=pip3
alias about='system_profiler SPHardwareDataType'

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source <(fzf --zsh)
alias f=fzf
alias fp='fzf --preview="bat --color=always {}"'
alias fv='nvim $(fzf -m --preview="bat --color=always {}")'
alias k=kubectl

alias bootstraps='~/dotfiles/scripts/tmux-init.sh'

# Go configuration
export GOPATH="$HOME/go"
export PATH="/usr/local/go/bin:$GOPATH/bin:$PATH"
export GOTOOLCHAIN=auto

export PATH=~/.npm-global/bin:$PATH
export PATH=~/.local/bin:$PATH

eval "$(zoxide init zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export KUBECONFIG=$HOME/.kube/homelab

export JAVA_HOME=$(/usr/libexec/java_home -v 21)
export PATH="$JAVA_HOME/bin:$PATH"
