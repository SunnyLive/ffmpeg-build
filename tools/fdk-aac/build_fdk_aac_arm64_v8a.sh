#!/bin/bash

# fdk-aac 源码目录
FDK_AAC_SOURCE=${ROOT_SOURCE}/build/fdk-aac
# 输出路径
PREFIX=${FDK_AAC_SOURCE}/android/arm64-v8a

export AS=$TOOLCHAIN/bin/aarch64-linux-android-as

CFLAGS=" "

FLAGS="--enable-static --host=aarch64-linux-android --target=android --disable-asm"

export CXXFLAGS=$CFLAGS
export CFLAGS=$CFLAGS

cd ${FDK_AAC_SOURCE}
./configure $FLAGS \
--enable-pic \
--enable-strip \
--prefix=${PREFIX}

make clean
make -j24
make install


