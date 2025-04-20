#!/bin/bash

source /etc/environment

# echo 'if [ -f /etc/environment ]; then' >> ~/.bashrc
# echo '    export $(grep -v "^#" /etc/environment | xargs)' >> ~/.bashrc
# echo 'fi' >> ~/.bashrc
# echo 'export PATH="$(uv python list | grep $PYTHON_VERSION | awk '\''{print $2}'\'' | xargs dirname):$PATH"' >> ~/.bashrc

if [ -f /etc/environment ]; then
    export $(grep -v "^#" /etc/environment | xargs)
fi
# export PATH="$(uv python list | grep $PYTHON_VERSION | awk '{print $2}' | xargs dirname):$PATH"

export UV_CACHE_DIR="$CACHE_DIR/uv"
export RENV_PATHS_ROOT="$CACHE_DIR/renv"
export ENV_DIR="$CACHE_DIR/env"

if [ ! -r "$CACHE_DIR" ] || [ ! -w "$CACHE_DIR" ] || [ ! -x "$CACHE_DIR" ]; then
    echo "Permission denied: the cache directory cannot be accessed with full permissions."
    exit 1
fi

if [ ! -r "$PROJ_DIR" ] || [ ! -w "$PROJ_DIR" ] || [ ! -x "$PROJ_DIR" ]; then
    echo "Permission denied: the project directory cannot be accessed with full permissions."
    exit 1
fi

mkdir -p $UV_CACHE_DIR
mkdir -p $RENV_PATHS_ROOT
mkdir -p $ENV_DIR

export LC_ALL=ja_JP.UTF-8

export PATH=$PATH:/usr/local/etc/prem

eval "$(direnv hook bash)"
cp /usr/local/etc/.envrctemp $PROJ_DIR/.envrc
direnv allow $PROJ_DIR

for dir in $PROJ_DIR/*/; do
    [ -d "$dir" ] || continue  # ディレクトリでない場合はスキップ
    if [ -L "$dir/.venv" ] || [ -d "$dir/.venv" ]; then  # .venv が存在する場合
        ENVRC_PATH="$dir/.envrc"

        # すでに .envrc が存在し、適切な内容が含まれているか確認
        if [ -f "$ENVRC_PATH" ] && grep -q "source .venv/bin/activate" "$ENVRC_PATH"; then
            direnv allow "$dir"
            continue  # 既に適切な .envrc がある場合はスキップ
        fi

        # .envrc を作成/更新
        echo "source .venv/bin/activate" > "$ENVRC_PATH"
        direnv allow "$dir"
    fi
done

cd $PROJ_DIR