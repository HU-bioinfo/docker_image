print("Loading .Rprofile...")
if (!"utils" %in% loadedNamespaces()) {
    library(utils)
}
if (file.exists("renv.lock")) {
    print("Loading renv...")
    renv::load()
    
    # 必要なパッケージの確認とインストール
    if (!requireNamespace("BiocManager", quietly = TRUE)) {
        renv::install("BiocManager", prompt = FALSE, lock = TRUE)
    }
    if (!requireNamespace("languageserver", quietly = TRUE)) {
        renv::install("languageserver", prompt = FALSE, lock = TRUE)
    }
    if (!requireNamespace("pak", quietly = TRUE)) {
        renv::install("pak", prompt = FALSE, lock = TRUE)
    }
    
    # BiocManagerの読み込み
    if (!"BiocManager" %in% loadedNamespaces()) {
        library(BiocManager)
    }
    
    # p3mミラーの設定
    options(
        BioC_mirror = "https://p3m.dev/bioconductor/latest",
        BIOCONDUCTOR_CONFIG_FILE = "https://p3m.dev/bioconductor/latest/config.yaml",
        repos = c(CRAN = "https://p3m.dev/cran/__linux__/bookworm/latest")
    )
    
    # BiocManagerのリポジトリ設定を適用
    options(repos = BiocManager::repositories())
    
    # タイムアウト設定
    options(timeout = 3600)
    
    # renvとpakの連携設定
    # pakをrenvのインストールエンジンとして設定
    options(renv.config.install.function = function(pkgs, ...) {
        pak::pkg_install(pkgs, ask = FALSE, ...)
    })
    
    # pak用の設定
    options(
        pak.no_progress = FALSE,
        pak.suppress_startup = TRUE
    )
}
print(".Rprofile loaded successfully.")
# 最後の行は無視されるのかもしれない