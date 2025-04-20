#!/usr/bin/env bash

log_info() {
    echo -e "[INFO] $1"
}

log_error() {
    echo -e "[ERROR] $1" >&2
}

init() {
    local proj_name=$1
    local proj_path="$PROJ_DIR/$proj_name"
    local usage_msg="Usage: prem init <project_name> [-py | -r]"

    if [ "$#" -gt 2 ]; then
        log_error "Too much arguments"
        echo $usage_msg
        return 1
    elif [ "$#" -eq 1 ]; then
        set_venv
        set_renv
    else
        local type=$2
        
        if [ "$type" = "-py" ]; then
            set_venv
        elif [ "$type" = "-r" ]; then 
            set_renv
        else
            log_error "Invalid option type"
            echo $usage_msg
            return 1
        fi
    fi
}

set_venv() {
    # Check if Python environment already exists
    if [ -d "$ENV_DIR/$proj_name/.venv" ]; then
        log_error "Python env $proj_name already exists."
        return 1
    fi
    
    cd $PROJ_DIR
    uv init $proj_name
    cd $proj_path
    uv venv 
    
    mkdir -p $ENV_DIR/$proj_name
    mv $proj_path/.venv $ENV_DIR/$proj_name/.venv
    ln -s $ENV_DIR/$proj_name/.venv $proj_path/.venv
        echo "source .venv/bin/activate" >> "$proj_path/.envrc"

    rm main.py
    rm README.md
    
    mkdirs
}

set_renv() {
    # Check if Python environment already exists
    if [ -d "$ENV_DIR/$proj_name/renv" ]; then
        log_error "R env $proj_name already exists."
        return 1
    fi

    mkdir -p $proj_path
    cd $proj_path
    Rscript -e 'library(renv)' -e 'renv::init()' -e 'q()' --no-save

    mkdir -p $ENV_DIR/$proj_name
    mv $proj_path/renv $ENV_DIR/$proj_name/renv
    ln -s $ENV_DIR/$proj_name/renv $proj_path/renv

    mkdirs
}

mkdirs() {
    mkdir -p codes
    mkdir -p data
    mkdir -p output

    cd $proj_path
}

list() {
    # Check if there are any projects
    if [ -z "$(ls -A $PROJ_DIR 2>/dev/null)" ]; then
        log_info "No projects"
        return 0
    fi
    echo "Projects:"
    ls $PROJ_DIR -1 | sed 's/^/- /'
}

rm_proj() {
    local proj_name=$1
    local proj_path="$PROJ_DIR/$proj_name"
    if [ -d "$proj_path" ]; then
        echo "project $proj_name will be removed permanently. "
        read -p "Are you sure you want to proceed? (y/N): " answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            rm -rf "$PROJ_DIR/$proj_name"
            rm -rf "$ENV_DIR/$proj_name"
            log_info "Project $proj_name removed."
        else
            echo "Cancelled"
        fi
    else
        log_error "Project $proj_name does not exist."
        return 1
    fi
}

rm_all() {
    echo "All projects will be removed permanently. "
    read -p "Are you sure you want to proceed? (y/N): " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        rm -rf $PROJ_DIR/*/
        rm -rf $ENV_DIR/*/
        log_info "All projects removed."
    else
        echo "Cancelled"
    fi
}
