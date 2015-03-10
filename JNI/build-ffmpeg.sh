#!/bin/bash

CPU_CORE=12

# Test files.
if [ ! -e "ffmpeg" ]; then
    echo "Error: ffmpeg directory not found."
    exit 0
fi

if [ ! -e "config-ffmpeg.sh" ]; then
    echo "Error: config-ffmpeg.sh needed to make build result."
    exit 0
fi

if [ ! -e "build.sh" ]; then
    echo "Error: build.sh needed to make build result."
    exit 0
fi

cd ffmpeg
../config-ffmpeg.sh $1
make clean
make -j$CPU_CORE
cd ..

./build.sh ffmpeg.mx build $1
./copy_to_$1.sh ffmpeg.mx


