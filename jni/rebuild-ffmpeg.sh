#!/bin/bash

PREFIXNAME="build-ffmpeg"
TARGETS="neon tegra3 tegra2 v6_vfp v6 v5te x86_atom mips"
ALEVELS=(21   21     19     19     19 21   21       21)
CNT=0

for ITEM in $TARGETS
do
    LOGNAME="$PREFIXNAME-$TARGET.log"
    if [ -e $LOGNAME ]; then
        rm $LOGNAME
    fi
    if [ $CNT -gt 0 ]; then
        echo ""
        echo "///////////////////////////////////////////////////////////////////////"
        echo ""
    fi
    echo "Building target [$ITEM] as Application Platform level ${ALEVELS[$CNT]}..."
    ./build-ffmpeg.sh $ITEM ${ALEVELS[$CNT]} 2>&1 >> $LOGNAME | tee -a $LOGNAME
    CNT=($CNT+1)
done
