#!/bin/bash -e
export RED_COLOR='\e[1;31m'
export GREEN_COLOR='\e[1;32m'
export YELLOW_COLOR='\e[1;33m'
export BLUE_COLOR='\e[1;34m'
export PINK_COLOR='\e[1;35m'
export SHAN='\e[1;33;5m'
export RES='\e[0m'

GROUP=
group() {
    endgroup
    echo "::group::  $1"
    GROUP=1
}
endgroup() {
    if [ -n "$GROUP" ]; then
        echo "::endgroup::"
    fi
    GROUP=
}

# script url
export mirror=http://127.0.0.1:8080

# private gitea
export gitea="gitea.kejizero.xyz"

# github mirror
export github="github.com"

# Check root
if [ "$(id -u)" = "0" ]; then
    export FORCE_UNSAFE_CONFIGURE=1 FORCE=1
fi

# Start time
starttime=`date +'%Y-%m-%d %H:%M:%S'`
CURRENT_DATE=$(date +%s)

# Cpus
cores=`expr $(nproc --all) + 1`

# CURL_BAR
if curl --help | grep progress-bar >/dev/null 2>&1; then
    CURL_BAR="--progress-bar";
fi

# SUPPORTED_BOARDS
SUPPORTED_BOARDS=$(curl -fsSL $mirror/boards.txt)
if [ -z "$1" ] || ! echo "$SUPPORTED_BOARDS" | grep -qw "$1"; then
    echo -e "\n${RED_COLOR}Unsupported or missing board: '$1'.${RES}\n"
    echo -e "Usage:\n"

    for board in $SUPPORTED_BOARDS; do
        echo -e "$board: ${GREEN_COLOR}bash build.sh $board${RES}"
    done
    echo
    exit 1
fi
