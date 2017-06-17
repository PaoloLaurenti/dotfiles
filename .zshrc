source $HOME/dotfiles/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle fabiokiatkowski/exercism.plugin.zsh

# Load the theme.
antigen theme pygmalion

# Tell antigen that you're done.
antigen apply
