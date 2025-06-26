#!/bin/bash
set -e

# Rustのインストール
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
export PATH="/root/.cargo/bin:${PATH}"

# Typstのインストール
cargo install --git https://github.com/typst/typst --locked typst-cli

# 動作確認
typst --version