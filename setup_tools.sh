#!/bin/bash

RELEASE_NAME=ulx3s-2020.10.12-linux-x86_64

if [ ! -d "$RELEASE_NAME" ]; then
    curl -L https://github.com/alpin3/ulx3s/releases/download/v2020.10.12/$RELEASE_NAME.tar.gz > $RELEASE_NAME.tar.gz
    tar -xf $RELEASE_NAME.tar.gz
    rm $RELEASE_NAME.tar.gz
fi


export PATH=`readlink -f $RELEASE_NAME/bin`:$PATH
export GHDL_PREFIX=`readlink -f $RELEASE_NAME/ghdl/lib/ghdl`
