# antidote: da Homebrew su macOS, da ~/.antidote su Linux
if [[ "$OSTYPE" == darwin* ]]; then
  source "$(brew --prefix)/opt/antidote/share/antidote/antidote.zsh"
else
  source "$HOME/.antidote/antidote.zsh"
fi

export ERL_AFLAGS="-kernel shell_history enabled"

# compinit must run before plugins that call compdef at load time.
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

# Load plugins and theme (see .zsh_plugins.txt).
antidote load $HOME/dotfiles/.zsh_plugins.txt

. $HOME/dotfiles/custom.sh

export LESS=-FRX
export EDITOR=nano

if [[ "$OSTYPE" == darwin* ]]; then
  alias rest-net="sudo ifconfig en0 down && sudo ifconfig en0 up"
else
  alias rest-net="sudo /etc/init.d/network-manager restart"
fi