# ffmpeg4android (v2.4)
 - A FFmpeg library for Android API level 12, Refered to MX player open source.
 - Modified to do not refer to these libraries:
   - iconv(libiconv)
   - openssl(libopenssl)
   - opencl(libopencl)
   - MXutil(MXplayer's library archive)
   - and more libraries in has not dependancy on compiler built in libraries.

## Reference
- MX player home page : https://sites.google.com/site/mxvpen/ffmpeg
- MX player download page : https://sites.google.com/site/mxvpen/download

## Required
- Linux with Android NDK build environment (Windows not tested)
- ${NDK} must be exported in your terminal environmet. If not, refer to below section of "Environments".

## Your first checking issues
- Check your linux system: x86 or x86-64.
- Check your NDK tool-chain. (It requires latest version)

## Modified
- Updated source to version 2.4 (MXplayer open source is 1.7.x)
- Changed some NDK reference and bash shell scripts.
- Changed MX player building scripts to do not refer to additional libraries.
- Removed some external libraries: openssl, iconv ...

## Updated 21-07-2015
- Added option to use Application platform level for limit Android API level.
- Removed libMXutil dependency, This library doesn't need to use this.

## Environments
- You should be check by using "env | grep NDK".
- If you don't have configured ${NDK} exports, just edit ".bashrc" or ".profile" in your home directory.
- See below example.
~~~~~
export ANDROID_NDK=${HOME}/android-ndk-r10d
export ANDROID_TOOLCHAIN=${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.6/prebuilt/linux-x86/bin
export ANDROID_SYSROOT=${ANDROID_NDK}/platforms/android-19/arch-arm
export SYSROOT=${ANDROID_SYSROOT}
export ANDROID_BUILD_TOP=${ANDROID_NDK}
export NDK=${ANDROID_NDK}
export PATH=${PATH}:${ANDROID_NDK}
~~~~~

## How to build library?
- Move to cloned directory and go to sub directory named "JNI".
- You should see many files.
- You don't need use config-ffmpeg.sh directly in JNI directory. It may not works in stand alone.
- You should be use "build-ffmpeg.sh" or "rebuild-ffmpeg.sh" for build target or all of targets.

## How to make an Android project?
- You should see these files and a directory in base directory.
  1. AndroidManifest.xml
  2. default.properties
  3. /src/*
- These files required for your Android app. development.
- An empty example source placed in src directory and it belogs to MX player developer's unique name field.
- You should be change AndroidManifest.xml and source directory structure to create new own source. (or use Eclipse)
