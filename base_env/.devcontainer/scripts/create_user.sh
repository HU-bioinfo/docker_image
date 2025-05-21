#! /bin/bash

# グループが存在するか確認し、存在しない場合は作成
if ! getent group 1000 > /dev/null 2>&1; then
  groupadd -g 1000 user
fi

# ユーザーが存在するか確認し、存在しない場合は作成
if ! getent passwd 1000 > /dev/null 2>&1; then
  useradd -m -u 1000 -g 1000 -s /bin/bash user
fi

echo "ユーザー user (UID:1000, GID:1000) を作成しました"