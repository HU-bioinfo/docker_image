# ベースイメージ
FROM hubioinfows/lite_env:latest

USER root

# 追加ソフトウェアビルドスクリプト
COPY /scripts/installer/install_quarto.sh /build_scripts/install_quarto.sh
COPY /scripts/installer/install_typst.sh /build_scripts/install_typst.sh
COPY /scripts/installer/install_tinytex.sh /build_scripts/install_tinytex.sh
COPY /scripts/installer/install_nodejs.sh /build_scripts/install_nodejs.sh
COPY /scripts/installer/install_claude_code.sh /build_scripts/install_claude_code.sh

RUN chmod +x /build_scripts/*.sh

# Node.jsのインストール（install_depsの後、他のインストール前に実行）
RUN /build_scripts/install_nodejs.sh

# Quarto, Typstのインストール
RUN /build_scripts/install_quarto.sh && \
    /build_scripts/install_typst.sh

# tinytexのインストール
RUN Rscript --no-site-file -e "install.packages('tinytex', repos = 'https://ftp.yz.yamagata-u.ac.jp/pub/cran/', lib='/usr/local/lib/R/site-library')"

# 環境変数ファイルのコピー
COPY /scripts/LaTeX/ /usr/local/etc/LaTeX/
COPY /scripts/slides/ /usr/local/etc/slides/

# ファイルのパーミッション設定
RUN chown -R user:user /usr/local/etc/LaTeX/ && \
    chmod +x /usr/local/etc/LaTeX/* && \
    chown -R user:user /usr/local/etc/slides/ && \
    chmod +x /usr/local/etc/slides/*

# ビルドスクリプトのパーミッション設定
RUN chmod +x /build_scripts/install_tinytex.sh && \
    chmod +x /build_scripts/install_claude_code.sh && \
    chown user:user /build_scripts/install_tinytex.sh && \
    chown user:user /build_scripts/install_claude_code.sh

# ディレクトリの作成とパーミッション設定
RUN mkdir -p /home/user/.TinyTeX && \
    chown -R user:user /home/user/.TinyTeX

# ユーザーの切り替え
USER user
WORKDIR /home/user/

# TinyTeXのインストール
RUN /build_scripts/install_tinytex.sh

# Claude Codeのインストール
RUN /build_scripts/install_claude_code.sh

# デフォルトのシェルをbashに設定
SHELL ["/bin/bash", "-c"]
