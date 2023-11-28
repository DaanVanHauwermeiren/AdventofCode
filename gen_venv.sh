#!/bin/bash

# cd to the folder of this file
cd "$(dirname "$0")"

# Set version to 3.10.10 with pyenv
export PYENV_VERSION=3.10.10
# make a virtual environment in folder ./.venv
python3 -m venv .venv --prompt venv-AoC

# install some additional libs
.venv/bin/pip install -r requirements.txt