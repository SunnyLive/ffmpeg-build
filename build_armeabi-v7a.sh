#!/bin/sh
# 根目录
export ROOT_SOURCE=$(cd `dirname $0`; pwd)

export NDK=/home/karl/tools/android-ndk-r21e
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64
export SYSROOT=$NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot

# 编译的API
export ANDROID_API=19

export AR=$TOOLCHAIN/bin/arm-linux-androideabi-ar
export CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$ANDROID_API-clang
export CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$ANDROID_API-clang++
export LD=$TOOLCHAIN/bin/arm-linux-androideabi-ld
export RANLIB=$TOOLCHAIN/bin/arm-linux-androideabi-ranlib
export STRIP=$TOOLCHAIN/bin/arm-linux-androideabi-strip
export NM=$TOOLCHAIN/bin/arm-linux-androideabi-nm

# 编译目录是否存在
if [ ! -d "build" ]; then
  mkdir ${ROOT_SOURCE}/build/
fi

# 判断编译目录是否存在源码, 不存在则复制到编译目录
if [ ! -d "build/ffmpeg" ]; then
  cp -R ffmpeg/ ${ROOT_SOURCE}/build/ffmpeg/
fi

if [ ! -d "build/x264" ]; then
  cp -R x264/ ${ROOT_SOURCE}/build/x264/
fi

if [ ! -d "build/fdk-aac" ]; then
  cp -R fdk-aac/ ${ROOT_SOURCE}/build/fdk-aac/
fi

# 到工具目录执行编译
cd tools

# 编译x264
if [ ! -x "libx264/build_x264_armeabi-v7a.sh" ]; then
    echo "can not find x264 build script"
else
    chmod a+x ./libx264/build_x264_armeabi-v7a.sh
    ./libx264/build_x264_armeabi-v7a.sh
fi

# 编译fdk-aac
if [ ! -x "fdk-aac/build_fdk-aac_armeabi_v7a.sh" ]; then
    echo "can not find fdk-aac build script"
else
    chmod a+x ./fdk-aac/build_fdk-aac_armeabi_v7a.sh
    ./fdk-aac/build_fdk-aac_armeabi_v7a.sh
fi

# 编译ffmpeg
if [ ! -x "ffmpeg/build_ffmpeg_armeabi-v7a.sh" ]; then
  echo "can not find ffmpeg build script"
else
    chmod a+x ./ffmpeg/build_ffmpeg_armeabi-v7a.sh
    ./ffmpeg/build_ffmpeg_armeabi-v7a.sh
fi


