#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

cd "$SCRIPT_DIR"

KAGOME_SOURCE_DIR="$SCRIPT_DIR/kagome"
KAGOME_BUILD_DIR="$SCRIPT_DIR/build/kagome"
KAGOME_INSTALL_PREFIX="$SCRIPT_DIR/install"

KAGOME_DIRTY_FILES_NUM=$( cd "$KAGOME_SOURCE_DIR" && git update-index --refresh && git status --porcelain=v1 2>/dev/null | wc -l)
if (( KAGOME_DIRTY_FILES_NUM > 0 ))
then
  echo "Kagome source directory is dirty; Please commit and push changes"
  exit 1
fi
KAGOME_UNPUSHED_COMMITS=$( git cherry -v )

CURRENT_BRANCH=$( cd "$KAGOME_SOURCE_DIR" && git branch --show-current )
sed "/\$\$CURRENT_BRANCH\$\$/$CURRENT_BRANCH"

git submodule update --init

mkdir -p "$KAGOME_INSTALL_PREFIX"
mkdir -p "$KAGOME_BUILD_DIR"

cd "$KAGOME_SOURCE_DIR"

BUILD_THREADS="${BUILD_THREADS:-$(( $(nproc 2>/dev/null || sysctl -n hw.ncpu) + 1 ))}"

cmake -B "$KAGOME_BUILD_DIR" -DCMAKE_INSTALL_PREFIX="$KAGOME_INSTALL_PREFIX"
cmake --build "$KAGOME_BUILD_DIR" -- -j${BUILD_THREADS} install