#! /bin/bash

# グループが存在するか確認し、存在しない場合は作成
if ! getent group 1000 > /dev/null 2>&1; then
  groupadd -g 1000 user
fi

# ユーザーをsudoグループに追加
usermod -aG sudo user

# パスワードなしでsudoを使用できるように設定
echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "ユーザー user (UID:1000, GID:1000) を作成しました"
echo "sudoをパスワードなしで使用できるように設定しました"