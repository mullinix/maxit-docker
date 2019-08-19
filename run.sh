#!/bin/bash
if [ "$1" = "" ]; then
    SOURCE_DIR=$(pwd)
else
    SOURCE_DIR=$1
fi
echo "Working directory set to: ${SOURCE_DIR}"
docker run -it --rm \
    -v "$SOURCE_DIR"/:/data \
    -w /data mullinix/maxit

