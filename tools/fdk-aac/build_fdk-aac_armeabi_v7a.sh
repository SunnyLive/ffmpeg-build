#!/bin/bash

# fdk-aac 源码目录
FDK_AAC_SOURCE=${ROOT_SOURCE}/build/fdk-aac
# 输出路径
PREFIX=${FDK_AAC_SOURCE}/android/armeabi-v7a

export AS=$TOOLCHAIN/bin/arm-linux-androideabi-as

CFLAGS=""

FLAGS="--enable-static --host=arm-linux-android --target=android --disable-asm "

export CXXFLAGS=$CFLAGS
export CFLAGS=$CFLAGS

cd ${FDK_AAC_SOURCE}
./configure $FLAGS \
--enable-pic \
--enable-strip \
--prefix=${PREFIX}

$ADDITIONAL_CONFIGURE_FLAG
make clean
make -j24
make install


