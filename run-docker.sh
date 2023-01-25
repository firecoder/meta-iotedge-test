#!/bin/sh

######################################################
# run the docker container to build Chromium browser #
######################################################


# detect path to this running script
SCRIPT=$(realpath "$0" 2>/dev/null)
if [ -z "$SCRIPT" ]; then
    [ -z "$SCRIPT" ] && [ "$OS_SYSTEM" == "Linux" ] && SCRIPT=$(readlink -f "$0" 2>/dev/null)
    [ -z "$SCRIPT" ] && [ "$OS_SYSTEM" == "GNU" ] && SCRIPT=$(readlink -f "$0" 2>/dev/null)
    [ -z "$SCRIPT" ] && SCRIPT=$(python -c "import os; print(os.path.abspath('$0'));" 2>/dev/null)
    [ -z "$SCRIPT" ] && SCRIPT=$(ruby -e "puts File.expand_path('$0')" 2>/dev/null)
    [ -z "$SCRIPT" ] && SCRIPT=$0
fi
SCRIPTPATH=$(dirname "$SCRIPT")



# detect podman or docker
if [ "$OS_SYSTEM" == "Darwin" ]; then
    # podman has not been ported to macOS yet. Use Docker instead
    PODMAN=`whereis -b -q docker`

elif [ "$OS_SYSTEM" == "FreeBSD" ]; then
    # use podman on FreeBSD
    PODMAN=`whereis -b -q podman`
    [ -z "$PODMAN" ] && PODMAN=`whereis -b -q docker`

else
    PODMAN=`which podman`
    [ -z "$PODMAN" ] && PODMAN=`which docker`
fi

# TODO support windows with Cygwin or git-bash


exec $PODMAN run \
    -it \
    -v "$SCRIPTPATH":/yocto-build/local-git-repo \
    local/yocto-meta-browser-test:latest
