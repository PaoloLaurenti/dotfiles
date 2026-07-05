"""Test end-to-end su Linux via Testcontainers.

Avvia un container Debian pulito, esegue install.sh e verifica che
l'installazione produca una zsh funzionante con antidote, plugin e tema.

Richiede un Docker daemon attivo.
"""

import subprocess
from pathlib import Path

import pytest
from testcontainers.core.container import DockerContainer

DOTFILES_DIR = Path(__file__).resolve().parent.parent
HOME = "/root"
DOTFILES_HOME = f"{HOME}/dotfiles"


def sh(container, script, check=True):
    """Esegue uno script bash nel container e ritorna (exit_code, output)."""
    code, output = container.exec(["bash", "-lc", script])
    output = output.decode(errors="replace")
    if check and code != 0:
        raise AssertionError(f"comando fallito ({code}):\n{script}\n--- output ---\n{output}")
    return code, output


@pytest.fixture(scope="module")
def installed_container():
    container = (
        DockerContainer("debian:bookworm")
        .with_command("sleep infinity")
        .with_volume_mapping(str(DOTFILES_DIR), "/src", "ro")
    )
    with container:
        # Prerequisiti di un sistema Linux minimo (git/curl/zsh come da README).
        sh(container, "apt-get update -qq && apt-get install -y -qq git curl zsh sudo ca-certificates")
        # Simula un clone fresco in ~/dotfiles (custom.sh non è versionato).
        sh(container, f"cp -a /src {DOTFILES_HOME} && rm -rf {DOTFILES_HOME}/.git "
                      f"&& rm -f {DOTFILES_HOME}/custom.sh {DOTFILES_HOME}/.zsh_plugins.zsh")
        # Esegue l'installazione.
        sh(container, f"cd {DOTFILES_HOME} && SHELL=/bin/bash bash install.sh")
        yield container


def test_antidote_installed(installed_container):
    sh(installed_container, f"test -f {HOME}/.antidote/antidote.zsh")


def test_zshrc_symlink(installed_container):
    _, out = sh(installed_container, f"readlink {HOME}/.zshrc")
    assert out.strip() == f"{DOTFILES_HOME}/.zshrc"


def test_custom_sh_created(installed_container):
    sh(installed_container, f"test -f {DOTFILES_HOME}/custom.sh")


def test_zsh_starts_clean(installed_container):
    """La prima shell interattiva clona i plugin e deve partire senza errori."""
    code, out = sh(installed_container, "zsh -ic 'echo STARTED_OK; exit' 2>&1", check=False)
    assert code == 0, out
    assert "STARTED_OK" in out
    for marker in ("command not found", "no such file", "parse error"):
        assert marker not in out.lower(), out


def test_rest_net_is_linux_variant(installed_container):
    _, out = sh(installed_container, "zsh -ic 'alias rest-net; exit' 2>/dev/null")
    assert "network-manager" in out
    assert "ifconfig" not in out


def test_pygmalion_theme_loaded(installed_container):
    _, out = sh(installed_container, "zsh -ic 'whence -w git_prompt_info; print -r -- $PROMPT; exit' 2>/dev/null")
    assert "git_prompt_info: function" in out
    # Il prompt di pygmalion contiene la sequenza utente@host:path
    assert "%n" in out and "%m" in out
