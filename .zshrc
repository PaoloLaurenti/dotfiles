source ./dot-files/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle command-not-found

# Load the theme.
antigen-theme pygmalion

# Tell antigen that you're done.
antigen apply

export HOMEBREW_GITHUB_API_TOKEN=631f17d79dfd6d80af73b4c4e5fc91edbc6489fa
PATH=/usr/local/bin:$PATH
alias gcfg='/usr/local/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
