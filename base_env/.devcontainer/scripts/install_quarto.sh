#!/bin/bash
set -e

# 一時ディレクトリ
TEMP_DIR=$(mktemp -d)

# 公式サイトから最新のdebファイルを一時ディレクトリにダウンロード
wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.7.31/quarto-1.7.31-linux-amd64.deb -P $TEMP_DIR

# パッケージをインストール
dpkg -i $TEMP_DIR/quarto-1.7.31-linux-amd64.deb

# 一時ディレクトリを削除
rm -rf $TEMP_DIR

quarto check
