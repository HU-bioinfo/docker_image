# ベースイメージ
FROM ubuntu:24.04

# Debianのフロントエンドを非対話型に設定
ENV DEBIAN_FRONTEND=noninteractive

# ビルド環境の設定ファイル
COPY /scripts/build.env /etc/build.env

# ビルドスクリプト
COPY /scripts/setup.sh /build_scripts/setup.sh
COPY /scripts/install_py.sh /build_scripts/install_py.sh
COPY /scripts/install_r.sh /build_scripts/install_r.sh
COPY /scripts/install_deps.sh /build_scripts/install_deps.sh
COPY /scripts/install_quarto.sh /build_scripts/install_quarto.sh
COPY /scripts/install_typst.sh /build_scripts/install_typst.sh
COPY /scripts/install_tinytex.sh /build_scripts/install_tinytex.sh

# 基本依存パッケージのインストール
RUN apt-get update && \
    apt-get install apt-utils wget ca-certificates direnv locales tzdata -y --no-install-recommends && \
    apt-get update 

# setup, install_py, install_rの実行
RUN eval export $(grep -v '^#' /etc/build.env | xargs) && \
    eval echo $(grep -v '^#' /etc/build.env | xargs) >> /etc/environment && \
    chmod +x /build_scripts/*.sh && \
    /build_scripts/setup.sh && \
    /build_scripts/install_py.sh && \
    /build_scripts/install_r.sh && \
    apt-get purge -y --auto-remove apt-utils

# install_depsの実行
RUN /build_scripts/install_deps.sh && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/* 

# Quarto, Typstのインストール
RUN /build_scripts/install_quarto.sh && \
    /build_scripts/install_typst.sh

# radianのインストール
RUN pip3 install -U radian --break-system-packages

# 環境変数ファイルのコピー
COPY /scripts/.envrc /usr/local/etc/.envrctemp
COPY /scripts/.Rprofile /usr/local/etc/R/.Rprofile
COPY /scripts/add_bashrc.sh /usr/local/bin/add_bashrc.sh
COPY /scripts/prem/ /usr/local/etc/prem/
COPY /scripts/install-files/install_util_packages.R /usr/local/etc/scripts/
COPY /scripts/LaTeX/ /usr/local/etc/LaTeX/
COPY /scripts/slides/ /usr/local/etc/slides/

# スクリプトディレクトリの作成
RUN mkdir -p /usr/local/etc/scripts && \
    chmod +x /usr/local/etc/scripts/install_util_packages.R

# ファイルのパーミッション設定
RUN chmod +x /usr/local/bin/add_bashrc.sh && \
    chown -R user:normal /usr/local/etc/prem/ && \
    chmod +x /usr/local/etc/prem/* && \
    chown -R user:normal /usr/local/etc/LaTeX/ && \
    chmod +x /usr/local/etc/LaTeX/* && \
    chown -R user:normal /usr/local/etc/slides/ && \
    chmod +x /usr/local/etc/slides/*

# TinyTeXビルドスクリプトのパーミッション設定
RUN chmod +x /build_scripts/install_tinytex.sh
RUN chown user:normal /build_scripts/install_tinytex.sh

# ディレクトリの作成とパーミッション設定
RUN mkdir -p /home/user/cache && \
    mkdir -p /home/user/proj && \
    chown -R user:normal /home/user/cache && \
    chown -R user:normal /home/user/proj

# ユーザーの切り替え
USER user
WORKDIR /home/user/

# add_bashrc.shの実行
RUN cat /usr/local/bin/add_bashrc.sh >> /home/user/.bashrc

# デフォルトのシェルをbashに設定
SHELL ["/bin/bash", "-c"]
