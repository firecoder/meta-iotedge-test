#!/bin/bash

# detect path to this running script
SCRIPT=$(realpath "$0" 2>/dev/null)
if [ -z "$SCRIPT" ]; then
    OS_SYSTEM="$(uname -s)"
    [ -z "$SCRIPT" ] && [ "$OS_SYSTEM" == "Linux" ] && SCRIPT=$(readlink -f "$0" 2>/dev/null)
    [ -z "$SCRIPT" ] && [ "$OS_SYSTEM" == "GNU" ] && SCRIPT=$(readlink -f "$0" 2>/dev/null)
    [ -z "$SCRIPT" ] && SCRIPT=$(python -c "import os; print(os.path.abspath('$0'));" 2>/dev/null)
    [ -z "$SCRIPT" ] && SCRIPT=$(ruby -e "puts File.expand_path('$0')" 2>/dev/null)
    [ -z "$SCRIPT" ] && SCRIPT=$0
fi
SCRIPTPATH=$(dirname "$SCRIPT")

BUILD_ROOT=/yocto-build
cd "$BUILD_ROOT"


# for python3 this is needed
export LANG=en_US.UTF-8


# download and prepare "repo" tool
REPO="$BUILD_ROOT"/tools/repo
if [ ! -e "$REPO" ]; then
    mkdir "$BUILD_ROOT"/tools
    wget http://commondatastorage.googleapis.com/git-repo-downloads/repo -O  "$REPO"
    chmod a+x "$REPO"
fi
export PATH="$BUILD_ROOT"/tools:${PATH}


# set Git identity for REPO
git config --global user.name "Yocto test user"
git config --global user.email "foo@bar.none"



if [ ! -d "$BUILD_ROOT/sources" ]; then
    # init repo manifest
    "$REPO"  init --manifest-url file:///yocto-build/local-git-repo --manifest-branch kirkstone -m yocto/manifests/yocto-kirkstone.xml
fi

# fetch all sources
"$REPO" sync

# copy Yocto configuration
mkdir -p build/conf
[ ! -f "$BUILD_ROOT/build/conf/local.conf" ] && cp "$BUILD_ROOT"/local-git-repo/yocto/local.conf build/conf/

# activate build environment settings and PATH to bitbake
source "$BUILD_ROOT"/sources/poky/oe-init-build-env build


# add the required layers
for layer in \
    meta-clang \
    meta-intel \
    meta-openembedded/meta-oe \
    meta-openembedded/meta-filesystems \
    meta-openembedded/meta-networking \
    meta-openembedded/meta-python \
    meta-openembedded/meta-perl \
    meta-virtualization \
    meta-security \
    meta-security/meta-tpm \
    meta-clang \
    meta-iotedge \
; do
    bitbake-layers add-layer ../sources/$layer
done


