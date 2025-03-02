#!/usr/bin/env bash

set -euo pipefail

PROOT="$PWD"
GIT_HASH=$(git rev-parse HEAD)
BUILD_DIR="$PROOT/build"
DIST_DIR="$PROOT/dist"
source /etc/os-release
: "${BUILDING_PLATFORM:=$PRETTY_NAME}"
PDFLATEX_VERSION=$(pdflatex -version | head -n 1)

fail() {
	echo "Error: " "$@" >/dev/stderr
	exit 1
}

log() {
	echo "$@" >/dev/stderr
}

if [[ -d "$BUILD_DIR" ]]; then
	log "Clean up the build dir..."
	rm -rf $BUILD_DIR/* || fail
else
	log "the build directory does not exsist!"
	log "creating a new build directory.."
	mkdir $BUILD_DIR || fail
fi

cp ./resume.tex ./latexmk $BUILD_DIR || fail

cd $BUILD_DIR || fail

sed -i "s/@{GIT_HASH}/$GIT_HASH/g" resume.tex || fail
sed -i "s/@{BUILDING_PLATFORM}/$BUILDING_PLATFORM/g" resume.tex || fail
sed -i "s/@{PDFLATEX_VERSION}/$PDFLATEX_VERSION/g" resume.tex || fail

latexmk -pdf resume.tex || fail

if [[ ! -d "$DIST_DIR" ]]; then
	mkdir -p "$DIST_DIR"
fi

cp resume.pdf "$DIST_DIR/anas-resume-$GIT_HASH.pdf"

echo "anas-resume-$GIT_HASH.pdf" >output_path
