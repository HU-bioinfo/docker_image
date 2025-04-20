if (!"utils" %in% loadedNamespaces()) {
    library(utils)
}

if (file.exists("renv.lock")) {
    print("renv.lock found. Loading renv.")

    global_lib_dir <- .libPaths()[1]
    renv::load()
    .libPaths(c(.libPaths(), global_lib_dir))

    if (!"BiocManager" %in% loadedNamespaces()) {
        library(BiocManager)
    }

    options(
        BioC_mirror = "https://p3m.dev/bioconductor/latest",
        BIOCONDUCTOR_CONFIG_FILE = "https://p3m.dev/bioconductor/latest/config.yaml",
        repos = c(CRAN = "https://p3m.dev/cran/__linux__/bookworm/latest")
    )
    options(repos = BiocManager::repositories())
}    

    # # R_ENV_PATH 環境変数が設定されている場合、そのパスの renv/activate.R を読み込む
    # # renv_activate <- file.path(Sys.getenv("R_ENV_PATH", unset = ""), "renv/activate.R")
    # # if (file.exists(renv_activate)) {
    # #     source(renv_activate)
    # # } else {
    # #     warning("The specified renv activation script does not exist.")
    # # }

# }