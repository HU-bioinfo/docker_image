#!/bin/bash

wget -qO- https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/usr/local/bin" sh

mkdir -p -m 777 $UV_PYTHON_INSTALL_DIR
uv python install $PYTHON_VERSION --preview --default
uv python install 3.12.10