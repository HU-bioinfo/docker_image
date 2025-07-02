# ベースイメージ
FROM rocker/r-ver:4.4.3

# Debianのフロントエンドを非対話型に設定
ENV DEBIAN_FRONTEND=noninteractive

# ビルド環境の設定ファイル
COPY scripts/build.env /etc/build.env

# ビルドスクリプト
COPY scripts/setup.sh /build_scripts/setup.sh
COPY scripts/create_user.sh /build_scripts/create_user.sh
COPY scripts/installer/install_py.sh /build_scripts/install_py.sh
COPY scripts/installer/install_deps.sh /build_scripts/install_deps.sh

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
    apt-get purge -y --auto-remove apt-utils

# install_depsの実行
RUN /build_scripts/install_deps.sh && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/* 

# renvのインストール
RUN Rscript --no-site-file -e "install.packages('renv', repos = 'https://ftp.yz.yamagata-u.ac.jp/pub/cran/', lib='/usr/local/lib/R/site-library')"

# radianのインストール
RUN eval export $(grep -v '^#' /etc/build.env | xargs) && \
    uv tool install radian

# uv toolのPATH設定
ENV PATH="/root/.local/bin:${PATH}"

# 環境変数ファイルのコピー
COPY scripts/.envrc /usr/local/etc/.envrctemp
COPY scripts/.Rprofile /usr/local/etc/R/.Rprofile
COPY scripts/add_bashrc.sh /usr/local/bin/add_bashrc.sh
COPY scripts/prem/ /usr/local/etc/prem/
COPY scripts/install-files/install_util_packages.R /usr/local/etc/scripts/

# スクリプトディレクトリの作成
RUN mkdir -p /usr/local/etc/scripts && \
    chmod +x /usr/local/etc/scripts/install_util_packages.R

# ユーザー設定
RUN /build_scripts/create_user.sh

# ファイルのパーミッション設定
RUN chmod +x /usr/local/bin/add_bashrc.sh && \
    chown -R user:user /usr/local/etc/prem/ && \
    chmod +x /usr/local/etc/prem/* 

# ディレクトリの作成とパーミッション設定
RUN mkdir -p /home/user/cache && \
    mkdir -p /home/user/proj && \
    chown -R user:user /home/user/cache && \
    chown -R user:user /home/user/proj 

# ユーザーの切り替え
USER user
WORKDIR /home/user/

# add_bashrc.shの実行
RUN cat /usr/local/bin/add_bashrc.sh >> /home/user/.bashrc

# デフォルトのシェルをbashに設定
SHELL ["/bin/bash", "-c"]
