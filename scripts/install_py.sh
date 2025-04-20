#!/bin/bash

wget -qO- https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/usr/local/bin" sh

# export PYTHON_VERSION="3.12"
# export UV_PYTHON_INSTALL_DIR="/opt/Python"

mkdir $UV_PYTHON_INSTALL_DIR
chmod 777 $UV_PYTHON_INSTALL_DIR
uv python install $PYTHON_VERSION --preview --default