#!/bin/bash
set -e

# アーキテクチャ判別
ARCH=$(dpkg --print-architecture)
# または
# ARCH=$(uname -m)
# if [ "$ARCH" = "x86_64" ]; then ARCH="amd64"; elif [ "$ARCH" = "aarch64" ]; then ARCH="arm64"; fi

# バージョン指定
QUARTO_VERSION="1.7.31"

# URLとファイル名を切り替え
DEB_URL="https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${ARCH}.deb"
DEB_FILE="quarto-${QUARTO_VERSION}-linux-${ARCH}.deb"

TEMP_DIR=$(mktemp -d)
wget "$DEB_URL" -P "$TEMP_DIR"
dpkg -i "$TEMP_DIR/$DEB_FILE"
rm -rf "$TEMP_DIR"

quarto check
