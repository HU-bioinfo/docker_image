#!/bin/bash

# Node.jsのインストール（最新LTS版）
echo "Node.jsのインストールを開始します..."

# 必要なパッケージのインストール
apt-get update
apt-get install -y ca-certificates curl gnupg

# NodeSourceリポジトリの設定
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

# Node.js 20.x（LTS）の設定
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# Node.jsのインストール
apt-get update
apt-get install -y nodejs

# クリーンアップ
apt-get autoremove -y
apt-get autoclean -y
rm -rf /var/lib/apt/lists/*

# バージョン確認
echo "Node.js $(node --version) をインストールしました"
echo "npm $(npm --version) をインストールしました"