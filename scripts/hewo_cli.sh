#!/bin/bash

# Ejecuta la CLI de Python
hewo() {
    python3 "$HOME/ThinThoughtProjects/HeWo/scripts/hewo_cli.py" "$@"
}

# Autocompletado para la CLI de HeWo
_hewo_completions() {
    local cur prev opts modules_dir
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    modules_dir="$HOME/ThinThoughtProjects/HeWo/modules"

    opts="build run deploy stop"

    if [[ "${COMP_CWORD}" == 1 ]]; then
        COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
    elif [[ "${COMP_WORDS[1]}" == "build" || "${COMP_WORDS[1]}" == "deploy" ]]; then
        local module_opts=$(ls "$modules_dir")
        COMPREPLY=( $(compgen -W "${module_opts}" -- "${cur}") )
    elif [[ "${COMP_WORDS[1]}" == "run" ]]; then
        local run_opts=$(ls "$modules_dir")
        COMPREPLY=( $(compgen -W "${run_opts}" -- "${cur}") )
    fi
}

# Registrar el autocompletado
complete -F _hewo_completions hewo

