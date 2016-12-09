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

source .cred.sh

PATH=/usr/local/bin:$PATH

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

alias gitconfig='/usr/local/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
