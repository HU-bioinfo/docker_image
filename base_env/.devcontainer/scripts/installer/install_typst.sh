#!/bin/bash
set -e

# ユーザーのホームディレクトリを使用
if [ "$(id -u)" = "0" ]; then
    # rootユーザーの場合、userユーザーのホームディレクトリを使用
    export CARGO_HOME="/home/user/.cargo"
    export RUSTUP_HOME="/home/user/.rustup"
else
    # 非rootユーザーの場合、現在のユーザーのホームディレクトリを使用
    export CARGO_HOME="$HOME/.cargo"
    export RUSTUP_HOME="$HOME/.rustup"
fi

# Rustのインストール
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
export PATH="$CARGO_HOME/bin:${PATH}"

# Typstのインストール
cargo install --git https://github.com/typst/typst --locked typst-cli

# 動作確認
typst --version

# rootユーザーで実行した場合、ディレクトリの所有権をuserに変更
if [ "$(id -u)" = "0" ]; then
    chown -R user:user "$CARGO_HOME"
    chown -R user:user "$RUSTUP_HOME"
fi