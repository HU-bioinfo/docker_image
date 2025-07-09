#!/bin/bash
set -e

# Claude Codeのインストール（userユーザー用）
echo "Claude Codeのインストールを開始します..."

# 現在のユーザーを確認
CURRENT_USER=$(whoami)
echo "現在のユーザー: $CURRENT_USER"

# userユーザーとして実行されているか確認
if [ "$CURRENT_USER" != "user" ]; then
    echo "エラー: このスクリプトはuserユーザーとして実行してください"
    exit 1
fi

# Node.jsとnpmの存在確認
echo "Node.jsのバージョン確認..."
if ! command -v node &> /dev/null; then
    echo "エラー: Node.jsがインストールされていません"
    exit 1
fi
node --version

echo "npmのバージョン確認..."
if ! command -v npm &> /dev/null; then
    echo "エラー: npmがインストールされていません"
    exit 1
fi
npm --version

# npmのグローバルディレクトリをユーザーのホームに設定
echo "npmのグローバルディレクトリを設定中..."
mkdir -p /home/user/.npm-global
npm config set prefix '/home/user/.npm-global'

# 現在のnpm設定を確認
echo "npm prefix: $(npm config get prefix)"

# Claude Codeのインストール
echo "Claude Codeをインストール中..."
npm install -g @anthropic-ai/claude-code

# インストール先の確認
echo "インストール先のファイルを確認..."
ls -la /home/user/.npm-global/bin/ || echo "binディレクトリが見つかりません"

# バージョン確認
export PATH=/home/user/.npm-global/bin:$PATH
echo "現在のPATH: $PATH"

if command -v claude &> /dev/null; then
    echo "Claude Codeのインストールが完了しました"
    claude --version
else
    echo "警告: Claude Codeのインストールを確認できませんでした"
    echo "claudeコマンドの場所を検索中..."
    find /home/user/.npm-global -name "claude" -type f 2>/dev/null || echo "claudeコマンドが見つかりません"
fi