# ffmpeg4android
A FFmpeg library for Android API level 12, Refered to MX player open source.

## Reference
- MX player home page : https://sites.google.com/site/mxvpen/ffmpeg
- MX player download page : https://sites.google.com/site/mxvpen/download

## Required
- Linux with Android NDK build environment (Windows not tested)
- ${NDK} must be exported in your terminal environmet. If not, refer to below section of "Environments".

## Modified
- Changed some NDK reference and bash shell scripts.

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

## How to build?
- Move to cloned directory and go to sub directory named "JNI".
- You should see many files.
- You don't need use config-ffmpeg.sh directly in JNI directory. It may not works in stand alone.
- You should be use "build-ffmpeg.sh" or "rebuild-ffmpeg.sh" for build target or all of targets.
