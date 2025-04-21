if (!"utils" %in% loadedNamespaces()) {
    library(utils)
}

if (file.exists("renv.lock")) {
    renv::load()

    if (!requireNamespace("BiocManager", quietly = TRUE)) {
        install.packages("BiocManager")
    }
    if (!requireNamespace("languageserver", quietly = TRUE)) {
        install.packages("languageserver")
    }

    if (!"BiocManager" %in% loadedNamespaces()) {
        library(BiocManager)
    }

    options(
        BioC_mirror = "https://p3m.dev/bioconductor/latest",
        BIOCONDUCTOR_CONFIG_FILE = "https://p3m.dev/bioconductor/latest/config.yaml",
        repos = c(CRAN = "https://p3m.dev/cran/__linux__/bookworm/latest")
    )
    options(repos = BiocManager::repositories())

    options(timeout=3600)
}