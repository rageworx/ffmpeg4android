#!/bin/bash
# Modified from MXplayer open source link:
#                    https://sites.google.com/site/mxvpen/download
# Written by Raphael, Kim <rage.kim@gmail.com>

# Testing envs.
if [ "$NDK" == "" ]; then
    echo "Error: Android NDK seems not configure to environment."
    exit 0
fi

HOST_PLATFORM=linux-x86
GCC_VER=4.8
APPLEVEL=22

case $1 in
	arm64)
		;;
	neon|tegra3)
		ARCH=arm
		CPU=armv7-a
		EXTRA_CFLAGS="-mfloat-abi=softfp -mfpu=neon -mtune=cortex-a8 -mvectorize-with-neon-quad"
		EXTRA_LDFLAGS="-Wl,--fix-cortex-a8"

		if [ $1 == 'tegra3' ] 
		then
			LIB_EXT="../libs/armeabi-v7a/tegra3"
			EXTRA_CFLAGS+=" -mno-unaligned-access"
			EXTRA_PARAMETERS="--disable-fast-unaligned"
		else
			LIB_EXT="../libs/armeabi-v7a/neon"
		fi
		;;
	tegra2)
		ARCH=arm
		CPU=armv7-a
		LIB_EXT="../libs/armeabi-v7a/vfpv3-d16"
		EXTRA_CFLAGS="-mfloat-abi=softfp -mfpu=vfpv3-d16"
		EXTRA_LDFLAGS="-Wl,--fix-cortex-a8"
		EXTRA_PARAMETERS="--disable-neon"
		;;
	v6_vfp)
		ARCH=arm
		CPU=armv6
        APPLEVEL=19
		LIB_EXT="../libs/armeabi-v6/vfp"
		EXTRA_CFLAGS="-mfloat-abi=softfp -mfpu=vfp"
		EXTRA_PARAMETERS="--disable-neon"
		;;
	v6)
		ARCH=arm
		CPU=armv6
        APPLEVEL=19
		LIB_EXT="../libs/armeabi-v6"
		EXTRA_CFLAGS="-msoft-float"
		EXTRA_PARAMETERS="--disable-neon --disable-vfp"
		;;
	v5te)
		ARCH=arm
		CPU=armv5te
        APPLEVEL=19
		LIB_EXT="../libs/armeabi-v5"
		EXTRA_CFLAGS="-msoft-float -mtune=xscale"
		EXTRA_PARAMETERS="--disable-neon --disable-armv6"
		;;
	x86_64)
		ARCH=x86_64
		CPU=atom
		LIB_EXT="../libs/x86_64"
		EXTRA_CFLAGS="-mtune=atom -msse3 -mssse3 -mfpmath=sse"
		;;
# pic not works even it exclueded in Android toolchain.
# We have some other build options for more platforms of Intel, but it only
# not works in any ATOM CPU type even in emulators.
# See more information of platform dependency:
# https://software.intel.com/en-us/android/blogs/2013/12/06/building-ffmpeg-for-android-on-x86
	x86)
		ARCH=x86
		CPU=atom
		LIB_EXT="../libs/x86"
		EXTRA_CFLAGS="-mtune=atom -msse3 -mssse3 -mfpmath=sse"

# Actually it supports sse4.2, but it embodied to each different ways.
# So we are recommend don't exclude SSE4.
#		EXTRA_PARAMETERS="--disable-sse4"
		;;
	x86_sse2)
		ARCH=x86
		CPU=i686
		LIB_EXT="../libs/x86-sse2"
		EXTRA_CFLAGS="-msse2 -mno-sse3 -mno-ssse3 -mfpmath=sse"
		EXTRA_PARAMETERS="--disable-sse3"
		;;
	mips)
		ARCH=mips
		CPU=mips32r2
		LIB_EXT="../libs/mips"
		EXTRA_CFLAGS=
		EXTRA_PARAMETERS="--disable-mipsfpu --disable-mipsdspr1 --disable-mipsdspr2"
		;;
	*)
		echo Unknown target: $1
		exit
esac

case $2 in
    19)
        APPLEVEL=19 ;;
    20)
        APPLEVEL=20 ;;
    21)
        APPLEVEL=21 ;;
    22)
        APPLEVEL=22 ;;
esac

if [ $ARCH == 'arm' ] 
then
	CROSS_PREFIX=$NDK/toolchains/arm-linux-androideabi-$GCC_VER/prebuilt/$HOST_PLATFORM/bin/arm-linux-androideabi-
	EXTRA_CFLAGS+=" -fstack-protector -fstrict-aliasing"
	EXTRA_LDFLAGS+=" -march=$CPU"
	OPTFLAGS="-O2"
	APP_PLATFORM=android-$APPLEVEL
	LINK_AGAINST=16-arm
elif [ $ARCH == 'x86_64' ] 
then
	CROSS_PREFIX=$NDK/toolchains/x86_64-$GCC_VER/prebuilt/$HOST_PLATFORM/bin/x86_64-linux-android-
	EXTRA_CFLAGS+=" -fstrict-aliasing"
	OPTFLAGS="-O2 -fno-pic"
	APP_PLATFORM=android-$APPLEVEL
	LINK_AGAINST=21-x86_64
elif [ $ARCH == 'x86' ] 
then
	CROSS_PREFIX=$NDK/toolchains/x86-$GCC_VER/prebuilt/$HOST_PLATFORM/bin/i686-linux-android-
	EXTRA_CFLAGS+=" -fstrict-aliasing"
	OPTFLAGS="-O2 -fno-pic"
	APP_PLATFORM=android-$APPLEVEL
	LINK_AGAINST=16-x86
elif [ $ARCH == 'mips' ] 
then
	CROSS_PREFIX=$NDK/toolchains/mipsel-linux-android-$GCC_VER/prebuilt/$HOST_PLATFORM/bin/mipsel-linux-android-
	EXTRA_CFLAGS+=" -fno-strict-aliasing -fmessage-length=0 -fno-inline-functions-called-once -frerun-cse-after-loop -frename-registers"
	OPTFLAGS="-O2"
	APP_PLATFORM=android-$APPLEVEL
	# Due to reference to missing symbol __fixdfdi on Novo 7 Paladin.
	LINK_AGAINST=15-mips
fi

# Testing paths.
TEST_RUN="${CROSS_PREFIX}gcc"
TEST_EXE=`${TEST_RUN} --version`
if [ "$TEST_EXE" == "" ]; then
    echo "Error: Android NDK gcc seems not works."
    exit 0
fi

SYS_ROOT="$NDK/platforms/$APP_PLATFORM/arch-$ARCH"
if [ ! -e $SYS_ROOT ]; then
    echo "Error: Android NDK system root not exists."
    echo "$SYS_ROOT"
    exit 0
fi

./configure \
--enable-static \
--disable-shared \
--enable-pic \
--enable-optimizations \
--enable-pthreads \
--disable-debug \
--disable-iconv \
--disable-doc \
--disable-programs \
--disable-symver \
--disable-avdevice \
--disable-postproc \
--disable-avfilter \
--disable-swscale-alpha \
--disable-encoders \
--disable-muxers \
--disable-devices \
--disable-filters \
--disable-opencl \
--disable-protocol=udplite \
--disable-demuxer=srt \
--disable-demuxer=microdvd \
--disable-demuxer=jacosub \
--disable-demuxer=sami \
--disable-demuxer=realtext \
--disable-demuxer=stl \
--disable-demuxer=subviewer \
--disable-demuxer=subviewer1 \
--disable-demuxer=pjs \
--disable-demuxer=vplayer \
--disable-demuxer=mpl2 \
--disable-demuxer=webvtt \
--disable-decoder=text \
--disable-decoder=srt \
--disable-decoder=subrip \
--disable-decoder=microdvd \
--disable-decoder=jacosub \
--disable-decoder=sami \
--disable-decoder=realtext \
--disable-decoder=movtext \
--disable-decoder=stl \
--disable-decoder=subviewer \
--disable-decoder=subviewer1 \
--disable-decoder=pjs \
--disable-decoder=vplayer \
--disable-decoder=mpl2 \
--disable-decoder=webvtt \
--enable-zlib \
--enable-network \
--enable-demuxer=rtsp \
--arch=$ARCH \
--cpu=$CPU \
--cross-prefix=$CROSS_PREFIX \
--enable-cross-compile \
--sysroot=$SYS_ROOT \
--target-os=linux \
--extra-cflags="-DNDEBUG -mandroid -ftree-vectorize -ffunction-sections -funwind-tables -fomit-frame-pointer -funswitch-loops -finline-limit=300 -finline-functions -fpredictive-commoning -fgcse-after-reload -fipa-cp-clone $EXTRA_CFLAGS -no-canonical-prefixes -pipe" \
--extra-libs="-L$LIB_EXT -L../libs/android/$LINK_AGAINST -lm" \
--extra-ldflags="$EXTRA_LDFLAGS" \
--optflags="$OPTFLAGS" \
$EXTRA_PARAMETERS \
\
\
--disable-decoder=dca \
--disable-demuxer=dts \
\
--disable-demuxer=ac3 \
--disable-demuxer=eac3 \
--disable-demuxer=mlp \
--disable-parser=mlp \
--disable-decoder=ac3 \
--disable-decoder=ac3_fixed \
--disable-decoder=eac3 \
--disable-decoder=mlp

