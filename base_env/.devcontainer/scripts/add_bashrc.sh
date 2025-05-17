#!/bin/bash

source /etc/environment

if [ -f /etc/environment ]; then
    export $(grep -v "^#" /etc/environment | xargs)
fi

if [ ! -r "$CACHE_DIR" ] || [ ! -w "$CACHE_DIR" ] || [ ! -x "$CACHE_DIR" ]; then
    echo "Permission denied: the cache directory cannot be accessed with full permissions."
    # 詳細なデバッグ情報を追加
    echo "CACHE_DIR permissions check:"
    echo "Read permission: $([ -r "$CACHE_DIR" ] && echo "OK" || echo "FAIL")"
    echo "Write permission: $([ -w "$CACHE_DIR" ] && echo "OK" || echo "FAIL")"
    echo "Execute permission: $([ -x "$CACHE_DIR" ] && echo "OK" || echo "FAIL")"
    exit 1
fi

if [ ! -r "$PROJ_DIR" ] || [ ! -w "$PROJ_DIR" ] || [ ! -x "$PROJ_DIR" ]; then
    echo "Permission denied: the project directory cannot be accessed with full permissions."
    # 詳細なデバッグ情報を追加
    echo "PROJ_DIR permissions check:"
    echo "Read permission: $([ -r "$PROJ_DIR" ] && echo "OK" || echo "FAIL")"
    echo "Write permission: $([ -w "$PROJ_DIR" ] && echo "OK" || echo "FAIL")"
    echo "Execute permission: $([ -x "$PROJ_DIR" ] && echo "OK" || echo "FAIL")"
    echo "PROJ_DIR actual path check:"
    stat $PROJ_DIR 2>&1 || echo "Failed to stat PROJ_DIR"
    exit 1
fi

export UV_CACHE_DIR="$CACHE_DIR/uv"
export RENV_PATHS_ROOT="$CACHE_DIR/renv"

mkdir -p $UV_CACHE_DIR
mkdir -p $RENV_PATHS_ROOT

export UV_GITHUB_TOKEN=$GITHUB_PAT
git config --global init.defaultBranch main

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

export PATH=$PATH:/usr/local/etc/prem

# cursor CLI ショートカット
cursor() {
  /vscode/cursor-server/bin/linux-x64/0781e811de386a0c5bcb07ceb259df8ff8246a50/bin/remote-cli/cursor "$@"
}

# TinyTeXのパスを追加（存在する場合）
if [ -d "/home/ubuntu/.TinyTeX/bin/x86_64-linux" ]; then
  export PATH="/home/ubuntu/.TinyTeX/bin/x86_64-linux:$PATH"
fi

# radianのエイリアスを"r"に設定
alias r="radian"
