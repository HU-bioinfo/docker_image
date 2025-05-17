#!/bin/bash
set -e

echo "TinyTeX Installation"

# インストール処理
Rscript --no-site-file -e "install.packages('tinytex')" 
Rscript --no-site-file -e "tinytex::install_tinytex(dir = '/home/ubuntu/.TinyTeX', force = TRUE)"

# パスを通す
export PATH="/home/ubuntu/.TinyTeX/bin/x86_64-linux:$PATH"

# TinyTeXが正しくインストールされているか確認
which tlmgr || { echo "tlmgr not found in PATH"; exit 1; }

# tlmgrのアップデートを実行（最大3回試行）
echo "Updating tlmgr itself..."
for i in {1..3}; do
  if tlmgr update --self; then
    echo "tlmgr successfully updated on attempt $i"
    break
  else
    echo "tlmgr update failed on attempt $i, retrying..."
    if [ $i -eq 3 ]; then
      echo "Failed to update tlmgr after 3 attempts, continuing anyway..."
    fi
    sleep 2
  fi
done

# 日本語環境用のパッケージをインストール（直接tlmgrコマンドを使用）
if which tlmgr > /dev/null; then
  echo "Installing Japanese language packages..."
  tlmgr install haranoaji bxjscls luatexja zxjatype zxjafont bxcjkjatype type1cm || { 
    echo "Failed to install packages with tlmgr, trying alternative method..."
    Rscript --no-site-file -e "tinytex::tlmgr_install(c('haranoaji', 'bxjscls', 'luatexja', 'zxjatype', 'zxjafont', 'bxcjkjatype', 'type1cm'))"
  }
else
  echo "tlmgrコマンドが見つかりません。代替方法を試みます。"
  Rscript --no-site-file -e "tinytex::tlmgr_install(c('haranoaji', 'bxjscls', 'luatexja', 'zxjatype', 'zxjafont', 'bxcjkjatype', 'type1cm'))"
fi

echo "TinyTeX Installation is done."