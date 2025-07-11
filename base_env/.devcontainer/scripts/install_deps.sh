#!/bin/bash

apt-get update
apt-get upgrade -y
apt-get install -y --fix-broken 
apt-get install -y --no-install-recommends \
    sudo \
    build-essential \
    ca-certificates \
    libssl-dev \
    libcurl4-openssl-dev \
    libreadline-dev \
    wget \
    libpcre2-8-0 \
    locales \
    tzdata \
    cmake \
    libzmq3-dev \
    libopenblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    g++ \
    gfortran \
    libsqlite3-dev \
    libxml2-dev \
    libxslt1-dev \
    libhdf5-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff-dev \
    git \
    gh \
    nvi \
    zlib1g-dev \
    libbz2-dev \
    tk \
    tk-dev \
    tk-table \
    libffi-dev \
    libfreetype6-dev \
    libfontconfig1-dev \
    libgmp3-dev \
    libmpfr-dev \
    libgsl0-dev \
    libcairo2-dev \
    libfftw3-dev \
    libx11-dev \
    libxt-dev \
    make \
    default-libmysqlclient-dev \
    unixodbc-dev \
    default-jdk \
    libxml2-dev \
    libssh2-1-dev \
    libglpk-dev \
    imagemagick \
    libmagick++-dev \
    gsfonts \
    libglu1-mesa-dev \
    libgl1-mesa-dev \
    libgdal-dev \
    gdal-bin \
    libgeos-dev \
    libproj-dev \
    libsodium-dev \
    libicu-dev \
    tcl \
    libfribidi-dev \
    libharfbuzz-dev \
    libudunits2-dev \
    pandoc \
    curl \
    gzip \
    tar \
    vim \
    htop \
    tree \
    dpkg \
    fonts-ipafont \
    python3-pip \
    pkg-config \
    software-properties-common \
    apt-utils \
    libjpeg62 \
    tesseract-ocr \
    tesseract-ocr-eng \
    tesseract-ocr-jpn

    # python3 \
    # libmariadb-dev-compat \
    # libmariadb-dev \