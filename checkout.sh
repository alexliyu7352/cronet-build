#!/bin/bash
# SPDX-FileCopyrightText: 2021, microG Project Team
# SPDX-License-Identifier: Apache-2.0

CHROMIUM_TAG=94.0.4594.1
CHROMIUM_REVISION=1b6b1b928764f3c0c3cb9902ebe39d70c1c9e5cd

ROOT=$PWD

if ! [ -d depot_tools ]; then
  echo "## Preparing depot_tools..."
  git clone "https://chromium.googlesource.com/chromium/tools/depot_tools.git"
fi

PATH=$ROOT/depot_tools:$PATH

if ! [ -d chromium ]; then
  echo "## Initializing chromium..."
  mkdir chromium
  cd chromium

  gclient config "https://chromium.googlesource.com/chromium/src.git"
  # echo 'target_os = ["android"]' >> .gclient

  git init -q src
  cd src
  git remote add -t $CHROMIUM_TAG origin "https://chromium.googlesource.com/chromium/src.git"
fi

cd "$ROOT/chromium/src"

echo "## Fetching chromium..."
# We need to make sure we have the commit with latest Change-Id
git fetch -q --depth=20 origin "$CHROMIUM_REVISION"
git checkout --detach "$CHROMIUM_REVISION"
git checkout "$CHROMIUM_REVISION"

echo "## Running gclient sync..."
gclient sync --no-history --nohooks --revision=$CHROMIUM_REVISION
