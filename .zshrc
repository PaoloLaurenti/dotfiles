source $HOME/dotfiles/antigen.zsh

alias sshantdev="ssh -p '60022' 'sviluppo@62.97.59.44'"

export ERL_AFLAGS="-kernel shell_history enabled"
export ELIXIR_GOL_GOOGLE_CLIENT_ID=19949297160-otcgr0konv1fivsf8se25q81rje4kg68.apps.googleusercontent.com
export ELIXIR_GOL_GOOGLE_CLIENT_SECRET=XCkRI-9uYgUZHgs1V952OxZr
export PATH=~/bin:$PATH

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle mix
antigen bundle heroku
antigen bundle npm
antigen bundle fabiokiatkowski/exercism.plugin.zsh
antigen bundle zsh-users/zsh-completions

# Load the theme.
antigen theme pygmalion

# Tell antigen that you're done.
antigen apply

autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

source ~/.asdf/asdf.sh
source ~/.asdf/completions/asdf.bash
source ~/dev/tools/kubectx/completion/kubens.bash
source ~/dev/tools/kubectx/completion/kubectx.bash
source <(kubectl completion zsh)

function fix-dotnet {
  DOTNET_BASE=$(dotnet --info | grep "Base Path" | awk '{print $3}')
  echo "DOTNET_BASE: ${DOTNET_BASE}"
  
  DOTNET_ROOT=$(echo $DOTNET_BASE | sed -E "s/^(.*)(\/sdk\/[^\/]+\/)$/\1/")
  echo "DOTNET_ROOT: ${DOTNET_ROOT}"
  
  export MSBuildSDKsPath=${DOTNET_BASE}Sdks/ 
  export DOTNET_ROOT=$DOTNET_ROOT
  export PATH=$DOTNET_ROOT:$PATH
}
