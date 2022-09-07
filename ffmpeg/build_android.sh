


#!/bin/bash

make clean

SYSROOT=/home/karl/tools/android-ndk-r23c/toolchains/llvm/prebuilt/linux-x86_64/sysroot
TOOLCHAIN=/home/karl/tools/android-ndk-r23c/toolchains/llvm/prebuilt/linux-x86_64

CPU=armv7-a
ARCH=arm
API=29

CROSS_PREFIX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-

CC=${CROSS_PREFIX}clang
CXX=CC=${CROSS_PREFIX}clang++

PREFIX=./android/${CPU}_${API}/
OPTIMIZE_CFLAGS="-march=$CPU"

./configure --target-os=android \
--prefix=$PREFIX \
--arch=$ARCH \
--cpu=$CPU \
--cc=$CC \
--cxx=$CXX \
--cpu=$CPU \
--strip=$TOOLCHAIN/bin/llvm-strip \
--nm=$TOOLCHAIN/bin/llvm-nm \
--enable-shared \
--disable-static \
--disable-doc \
--disable-x86asm \
--disable-yasm \
--disable-symver \
--enable-gpl \
--cross-prefix=$CROSS_PREFIX \
--enable-cross-compile \
--sysroot=$SYSROOT \
--extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS" \
--extra-ldflags="$ADDI_LDFLAGS" \
$ADDITIONAL_CONFIGURE_FLAG

make -j10
make install
# chmod -R 777 ./


