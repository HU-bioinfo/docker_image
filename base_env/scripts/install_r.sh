#!/bin/bash

wget -qO /etc/apt/trusted.gpg.d/rig.gpg https://rig.r-pkg.org/deb/rig.gpg
sh -c 'echo "deb http://rig.r-pkg.org/deb rig main" > /etc/apt/sources.list.d/rig.list'
apt-get update
apt-get install r-rig --no-install-recommends

mkdir -p -m 777 $R_LIBS_USER 
rig add $R_VERSION
rig default $R_VERSION
rig add 4.4.3

Rscript --no-site-file -e "install.packages('renv')"