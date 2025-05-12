#!/usr/bin/env bash

set -euo pipefail

PROOT="$PWD"
GIT_HASH=$(git rev-parse HEAD)
GPG_NUMBER_REV="TODO"
GPG_EMAIL='anas.elgarhy.dev@gmail.com'
BUILD_DIR="$PROOT/build"
DIST_DIR="$PROOT/dist"
source /etc/os-release
: "${BUILDING_PLATFORM:=$PRETTY_NAME}"
PDFLATEX_VERSION=$(pdflatex -version | head -n 1)

sed -i "s/@{GIT_HASH}/$GIT_HASH/g" resume.tex || fail
sed -i "s/@{GPG_NUMBER_REV}/$GPG_NUMBER_REV/g" resume.tex || fail
sed -i "s/@{GPG_EMAIL}/$GPG_EMAIL/g" resume.tex || fail
sed -i "s/@{BUILDING_PLATFORM}/$BUILDING_PLATFORM/g" resume.tex || fail
sed -i "s/@{PDFLATEX_VERSION}/$PDFLATEX_VERSION/g" resume.tex || fail
