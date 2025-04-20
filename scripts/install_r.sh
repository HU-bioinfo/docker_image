#!/bin/bash

wget -qO /etc/apt/trusted.gpg.d/rig.gpg https://rig.r-pkg.org/deb/rig.gpg
sh -c 'echo "deb http://rig.r-pkg.org/deb rig main" > /etc/apt/sources.list.d/rig.list'
apt-get update
apt-get install r-rig --no-install-recommends

rig add $R_VERSION
mkdir /usr/local/etc/R -p
mkdir /usr/local/lib/R/site-library/ -p
chmod -R 777 /usr/local/lib/R/site-library/
echo 'RENV_CONFIG_AUTOLOADER_ENABLED=FALSE' >> $R_ENVIRON

Rscript --no-site-file -e "
    install.packages('renv')
    install.packages('languageserver')
    install.packages('BiocManager')
    "