#!/usr/bin/env Rscript

# ユーティリティパッケージのインストール
print("Installing utility packages...")

# renvの読み込み
library(utils)
library(renv)

# 必要なパッケージの確認とインストール
## renv::install
if (!requireNamespace("BiocManager", quietly = TRUE)) {
    renv::install("BiocManager", prompt = FALSE, lock = TRUE)
}
if (!requireNamespace("languageserver", quietly = TRUE)) {
    renv::install("languageserver", prompt = FALSE, lock = TRUE)
}
if (!requireNamespace("pak", quietly = TRUE)) {
    renv::install("pak", prompt = FALSE, lock = TRUE)
}
if (!requireNamespace("remotes", quietly = TRUE)) {
    renv::install("remotes", prompt = FALSE, lock = TRUE)
}
if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    renv::install("rmarkdown", prompt = FALSE, lock = TRUE)
}

## remotes::install_github
library(remotes)
if (!requireNamespace("httpgd", quietly = TRUE)) {
    remotes::install_github("nx10/httpgd")
}

print("Utility packages installation completed.")

