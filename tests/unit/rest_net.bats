#!/usr/bin/env bats
# Verifica che l'alias rest-net scelga il comando giusto per ciascun OS,
# forzando OSTYPE e valutando il blocco if/else estratto dal .zshrc.

setup() {
  DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  ZSHRC="$DOTFILES_DIR/.zshrc"
}

# Estrae dal .zshrc il blocco if...fi che contiene "rest-net"
extract_rest_net_block() {
  awk '
    /^if \[\[ "\$OSTYPE"/ { buf = $0 ORS; inblk = 1; next }
    inblk { buf = buf $0 ORS }
    /^fi/ { if (inblk && buf ~ /rest-net/) print buf; inblk = 0; buf = "" }
  ' "$ZSHRC"
}

@test "il blocco rest-net esiste nel .zshrc" {
  block="$(extract_rest_net_block)"
  [ -n "$block" ]
}

@test "rest-net su macOS (OSTYPE=darwin*) usa ifconfig" {
  block="$(extract_rest_net_block)"
  run zsh -c "OSTYPE=darwin25.0
$block
alias rest-net"
  [ "$status" -eq 0 ]
  [[ "$output" == *"ifconfig en0"* ]]
  [[ "$output" != *"network-manager"* ]]
}

@test "rest-net su Linux (OSTYPE=linux-gnu) usa network-manager" {
  block="$(extract_rest_net_block)"
  run zsh -c "OSTYPE=linux-gnu
$block
alias rest-net"
  [ "$status" -eq 0 ]
  [[ "$output" == *"/etc/init.d/network-manager restart"* ]]
  [[ "$output" != *"ifconfig"* ]]
}
