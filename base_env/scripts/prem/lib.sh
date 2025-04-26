#!/usr/bin/env bash

log_info() {
    echo -e "[INFO] $1"
}

log_error() {
    echo -e "[ERROR] $1" >&2
}

set_venv() {
    uv init
    uv venv 

    echo "source .venv/bin/activate" > ${proj_path}/.envrc
    direnv allow $proj_path

    rm main.py
    rm README.md
}

set_renv() {
    Rscript -e 'library(renv)' -e 'renv::init()' -e 'q()' --no-save
    cp /usr/local/etc/R/.Rprofile $proj_path/.Rprofile
}

main() {
    local usage_msg="Usage: prem <project_name(option)>"
    if [ "$#" -gt 1 ]; then
        log_error "Too many arguments"
        echo $usage_msg
        return 1
    elif [ "$#" -eq 1 ]; then
        local proj_name=$1
        local proj_path="$PROJ_DIR/$proj_name"
        if [ ! -d "$proj_path" ]; then
            mkdir -p -m 777 "$proj_path"
            log_info "Created project folder: $proj_path"
        fi
        cd "$proj_path" || return 1
    else
        local proj_path=$(pwd)
        if [[ "$proj_path" != "$PROJ_DIR/"* ]]; then
            log_error "Current directory is not a valid project folder"
            return 1
        fi
        cd "$proj_path" || return 1
    fi

    # Initial setup
    if [ ! -d "$proj_path/.venv" ]; then
        log_info "Setting up Python virtual environment"
        set_venv
    fi
    if [ ! -d "$proj_path/renv" ]; then
        log_info "Setting up R environment"
        set_renv
    fi
    mkdir -p code
    mkdir -p data
    mkdir -p output
    if [ ! -d "$proj_path/.git" ]; then
        log_info "Initializing git repository"
        git init
        echo ".venv" >> .gitignore
        echo "renv" > .gitignore
        echo ".envrc" >> .gitignore
        echo ".Rprofile" >> .gitignore
    fi

    # Recreate environment from lock files
    if [ "$(stat -c %u $proj_path)" -eq "$(id -u)" ]; then
        if [ -f "$proj_path/uv.lock" ]; then
            log_info "Synchronizing Python environment from uv.lock"
            uv sync
        fi
        if [ -f "$proj_path/renv.lock" ]; then
            log_info "Restoring R environment from renv.lock"
            Rscript -e 'library(renv)' -e 'renv::restore()' -e 'q()' --no-save
        fi
    else
        log_error "Project $proj_name is not owned by the current user"
        echo "Run 'sudo chown -R 1001 $proj_name' in the project directory outside of this container"
        return 1
    fi
    
    cd $PWD
}