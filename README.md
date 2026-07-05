# dotfiles

Configurazione zsh cross-platform (macOS e Linux) basata su
[antidote](https://antidote.sh) come gestore dei plugin.

## Prerequisiti

- **macOS**: [Homebrew](https://brew.sh) (antidote viene installato con `brew`)
- **Linux (Debian/Ubuntu)**: `git`, `curl` (antidote viene clonato in `~/.antidote`;
  zsh viene installato con `apt-get` se assente)

## Install

Execute following commands to install configuration files.

    $ git clone https://github.com/paololaurenti/dotfiles.git ~/dotfiles
    $ cd ~/dotfiles
    $ ./install.sh

Il repo può risiedere in qualsiasi cartella (non deve per forza essere
`~/dotfiles`): il `.zshrc` risolve da sé la propria directory seguendo il
symlink `~/.zshrc`, quindi plugin e `custom.sh` vengono caricati dalla
posizione reale del repo.

Lo script:

- installa antidote (via Homebrew su macOS, via `git clone` su Linux);
- imposta zsh come shell di default se non lo è già;
- crea `custom.sh` (file per configurazioni locali/private, non versionato);
- crea il symlink `~/.zshrc` → `~/dotfiles/.zshrc`.

I plugin e il tema (`pygmalion`) sono elencati in `.zsh_plugins.txt` e vengono
scaricati da antidote al primo avvio della shell.

## Test

Test unitari (BATS) sulla logica dipendente dall'OS:

    $ bats tests/unit/

Test end-to-end Linux (richiede Docker attivo):

    $ python3 -m venv .venv
    $ source .venv/bin/activate
    $ pip install -r tests/requirements.txt
    $ python3 -m pytest tests/e2e_linux_test.py -v

Nota: usa `python3 -m pytest` (invece del comando `pytest`) così l'eseguibile
viene sempre risolto dal virtual environment attivo, evitando l'errore
`pytest: command not found`.

La CI (GitHub Actions) esegue entrambi su `ubuntu-latest` e l'installazione
nativa completa su `macos-latest`.
