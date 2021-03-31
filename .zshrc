source $HOME/dotfiles/antigen.zsh
source $HOME/dotfiles/custom.sh

export ERL_AFLAGS="-kernel shell_history enabled"

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle mix
antigen bundle heroku
antigen bundle npm
antigen bundle fabiokiatkowski/exercism.plugin.zsh
antigen bundle zsh-users/zsh-completions
antigen bundle jonmosco/kube-ps1
antigen bundle droctothorpe/kubecolor
antigen bundle mattbangert/kubectl-zsh-plugin

# Load the theme.
antigen theme pygmalion

# Tell antigen that you're done.
antigen apply

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
