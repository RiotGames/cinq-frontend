#!/usr/bin/env bash

set -e
PYENV=${TMPDIR}.pyenv

echo "Creating temporary python virtual env in ${PYENV}"
VENV_OUT=`python3 -m venv ${PYENV}`
PIP_OUT=`${PYENV}/bin/pip install -U setuptools_scm`

VERSION=`${PYENV}/bin/python -c 'import setuptools_scm; print(setuptools_scm.get_version())'`

if [[ ${VERSION} = *"dev"* ]]; then
    RELEASE="dev"
else
    RELEASE="release"
fi

# Install all the node modules required
echo "Installing node/npm modules"
npm i

echo "Building source code"
./node_modules/.bin/gulp build.prod

TARBALL="cinq-frontend-${VERSION}.tar.gz"
echo "Packaging release"
(cd dist && tar czf ${TMPDIR}${TARBALL} *)

echo "Uploading release"
aws s3 cp ${TMPDIR}${TARBALL} s3://releases.cloud-inquisitor.io/${RELEASE}/${TARBALL}
