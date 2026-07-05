#!/bin/bash

DOT_FILES_DIR="$( cd "$( dirname "$0" )" && pwd )"

echo "setup zsh"

echo "install antidote (zsh plugin manager)"
case "$(uname -s)" in
  Darwin)
    if brew list antidote > /dev/null 2>&1
    then
      echo "antidote is already installed"
    else
      brew install antidote
    fi
    ;;
  Linux)
    if [ -d "$HOME/.antidote" ]
    then
      echo "antidote is already installed"
    else
      git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
    fi
    ;;
esac

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

echo "custom.sh"
if [ -f "$DOT_FILES_DIR/custom.sh" ]
then
  echo "custom.sh already exists"
else
  touch "$DOT_FILES_DIR/custom.sh"
fi

echo ".zshrc"
rm -f ~/.zshrc && ln -sf "$DOT_FILES_DIR/.zshrc" ~/.zshrc

echo "done"
