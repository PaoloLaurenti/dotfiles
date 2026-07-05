#!/usr/bin/env bats
# Regressione: il .zshrc deve risolvere la propria directory seguendo il
# symlink ~/.zshrc, così i bundle (.zsh_plugins.txt, custom.sh) vengono
# caricati da dove vive davvero il repo e NON da un percorso fisso ~/dotfiles.
# Bug storico: "antidote load $HOME/dotfiles/.zsh_plugins.txt" falliva quando
# il repo era clonato altrove (es. ~/Dev/dotfiles).

setup() {
  DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  ZSHRC="$DOTFILES_DIR/.zshrc"
}

@test "il .zshrc non hardcoda il percorso ~/dotfiles" {
  # Nessun source deve puntare a un percorso fisso $HOME/dotfiles o ~/dotfiles.
  run grep -nE '(antidote load|^[[:space:]]*\.)[[:space:]].*(\$HOME/dotfiles|~/dotfiles)' "$ZSHRC"
  [ "$status" -ne 0 ]
}

@test "il .zshrc definisce DOTFILES_DIR risolvendo il proprio file" {
  run grep -qE 'DOTFILES_DIR=.*\{\(%\):-%N\}' "$ZSHRC"
  [ "$status" -eq 0 ]
}

# Estrae le righe che definiscono DOTFILES_DIR e caricano i bundle.
extract_path_lines() {
  grep -E '^(DOTFILES_DIR=|antidote load |\. )' "$ZSHRC"
}

@test "i bundle vengono risolti dalla directory reale del repo (repo fuori da ~/dotfiles)" {
  tmp="$(mktemp -d)"
  realdir="$tmp/Dev/personal/dotfiles"   # posizione arbitraria, non ~/dotfiles
  linkdir="$tmp/home"
  mkdir -p "$realdir" "$linkdir"

  extract_path_lines > "$realdir/.zshrc"
  : > "$realdir/custom.sh"                 # esiste così il "." non fallisce
  ln -s "$realdir/.zshrc" "$linkdir/.zshrc"  # simula ~/.zshrc -> repo altrove

  run env HOME="$linkdir" zsh -c "
antidote() { print -r -- \"ANTIDOTE_ARG:\$2\"; }
source '$linkdir/.zshrc'
print -r -- \"DOTFILES_DIR:\$DOTFILES_DIR\"
"
  [ "$status" -eq 0 ]
  # DOTFILES_DIR deve puntare alla directory reale, non a ~/dotfiles.
  [[ "$output" == *"DOTFILES_DIR:$realdir"* ]]
  # antidote deve caricare il bundle da quella directory.
  [[ "$output" == *"ANTIDOTE_ARG:$realdir/.zsh_plugins.txt"* ]]
  [[ "$output" != *"$linkdir/dotfiles"* ]]

  rm -rf "$tmp"
}
