#!/usr/bin/env bash

set -e
PYENV=/tmp/.pyenv

python3 -m venv ${PYENV}
${PYENV}/bin/pip install -U -r requirements.txt
${PYENV}/bin/python3 build.py build --verbose
