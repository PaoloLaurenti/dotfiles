#!/bin/bash

DOT_FILES_DIR="$( cd "$( dirname "$0" )" && pwd )"

echo "setup zsh"

if [ "$SHELL" = "/bin/zsh" ]
then
  echo "zsh is already the default shell"
else
  echo "check if zsh is already installed"

  if which "zsh"
  then
    echo "zsh is already installed"
  else
    echo "zsh is not installed yet..."
    echo ""
    sudo apt-get install zsh
    echo ""
    echo "zsh has been installed"
  fi

  echo "change default shell to zsh"

  if grep -q "zsh" /etc/shells
  then
    echo "zsh is already an authorized shell"
  else
    echo "make zsh an authorized shell"
    command -v zsh | sudo tee -a /etc/shells
  fi

  chsh -s $(which zsh)

  echo "zsh is now the default shell"
  echo "Please, log off and log in"
fi

echo "make links between $DOT_FILES_DIR and $HOME"

echo ".zshrc"
rm -f ~/.zshrc && ln -sf "$DOT_FILES_DIR/.zshrc" ~/.zshrc

echo "vscode .settings"
rm -f ~/.config/Code/User/settings.json && ln -sf "$DOT_FILES_DIR/vscode/settings.json" ~/.config/Code/User/settings.json

echo "done"
