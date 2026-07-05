#!/usr/bin/env bats
# Verifica che il .zshrc scelga il path corretto di antidote per ciascun OS.
# "source" e "brew" vengono stubbate per non dipendere dall'ambiente host.

setup() {
  DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  ZSHRC="$DOTFILES_DIR/.zshrc"
}

# Estrae dal .zshrc il blocco if...fi che contiene "antidote.zsh"
extract_antidote_block() {
  awk '
    /^if \[\[ "\$OSTYPE"/ { buf = $0 ORS; inblk = 1; next }
    inblk { buf = buf $0 ORS }
    /^fi/ { if (inblk && buf ~ /antidote\.zsh/) print buf; inblk = 0; buf = "" }
  ' "$ZSHRC"
}

@test "il blocco antidote esiste nel .zshrc" {
  block="$(extract_antidote_block)"
  [ -n "$block" ]
}

@test "su macOS antidote viene caricato dal prefix di Homebrew" {
  block="$(extract_antidote_block)"
  run zsh -c "
source() { print \"SOURCED:\$1\"; }
brew() { print /opt/homebrew; }
OSTYPE=darwin25.0
$block"
  [ "$status" -eq 0 ]
  [[ "$output" == *"SOURCED:/opt/homebrew/opt/antidote/share/antidote/antidote.zsh"* ]]
}

@test "su Linux antidote viene caricato da ~/.antidote" {
  block="$(extract_antidote_block)"
  run zsh -c "
source() { print \"SOURCED:\$1\"; }
OSTYPE=linux-gnu
HOME=/home/tester
$block"
  [ "$status" -eq 0 ]
  [[ "$output" == *"SOURCED:/home/tester/.antidote/antidote.zsh"* ]]
}
