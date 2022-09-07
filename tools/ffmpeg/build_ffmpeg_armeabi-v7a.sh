#!/bin/sh

#编译目录
BUILD_SOURCE=${ROOT_SOURCE}/build
#FFmpeg的源码目录
FFMPEG_SOURCE=${BUILD_SOURCE}/ffmpeg

# x264的目录
X264_INCLUDE=${BUILD_SOURCE}/x264/android/armeabi-v7a/include
X264_LIB=${BUILD_SOURCE}/x264/android/armeabi-v7a/lib

# fdk-aac的目录
FDK_AAC_INCLUDE=${BUILD_SOURCE}/fdk-aac/android/armeabi-v7a/include
FDK_AAC_LIB=${BUILD_SOURCE}/fdk-aac/android/armeabi-v7a/lib

# arm v7vfp
CPU=armeabi-v7a
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -march=armv7-a "
ADDI_CFLAGS="-marm"
PREFIX=${FFMPEG_SOURCE}/android/${CPU}

export AS=$TOOLCHAIN/bin/arm-linux-androideabi-as

cd $FFMPEG_SOURCE

# 移除旧的文件夹
rm -rf ${PREFIX}
# 重新创建新的文件夹
mkdir -p ${PREFIX}

# 配置
./configure \
--prefix=${PREFIX} \
--arch=arm \
--cpu=armv7-a \
--target-os=android \
--enable-cross-compile \
--cross-prefix=${TOOLCHAIN}/bin/arm-linux-androideabi- \
--sysroot=${SYSROOT} \
--extra-cflags="-I${X264_INCLUDE} -I${FDK_AAC_INCLUDE} -I${SYSROOT}/usr/include" \
--extra-ldflags="-L${X264_LIB} -L${FDK_AAC_LIB}" \
--cc=${CC} \
--ar=${AR} \
--cxx=${CXX} \
--ranlib=${RANLIB} \
--strip=${STRIP} \
--nm=${NM} \
--disable-shared \
--enable-nonfree \
--enable-static \
--enable-gpl \
--enable-version3 \
--enable-pthreads \
--enable-runtime-cpudetect \
--enable-small \
--enable-network \
--disable-iconv \
--enable-asm \
--enable-neon \
--enable-yasm \
--disable-encoders \
--enable-libfdk-aac \
--enable-libx264 \
--enable-encoder=h263 \
--enable-encoder=libx264 \
--enable-encoder=libfdk_aac \
--enable-encoder=aac \
--enable-encoder=mpeg4 \
--enable-encoder=mjpeg \
--enable-encoder=png \
--enable-encoder=gif \
--enable-encoder=bmp \
--disable-muxers \
--enable-muxer=h264 \
--enable-muxer=flv \
--enable-muxer=gif \
--enable-muxer=image2 \
--enable-muxer=mp3 \
--enable-muxer=dts \
--enable-muxer=mp4 \
--enable-muxer=mov \
--enable-muxer=mpegts \
--enable-muxer=rtsp \
--disable-decoders \
--enable-jni \
--enable-mediacodec \
--enable-decoder=h264_mediacodec \
--enable-hwaccel=h264_mediacodec \
--enable-decoder=aac \
--enable-decoder=aac_latm \
--enable-decoder=mp3 \
--enable-decoder=h263 \
--enable-decoder=h264 \
--enable-decoder=mpeg4 \
--enable-decoder=mjpeg \
--enable-decoder=gif \
--enable-decoder=png \
--enable-decoder=bmp \
--enable-decoder=yuv4 \
--disable-demuxers \
--enable-demuxer=image2 \
--enable-demuxer=h263 \
--enable-demuxer=h264 \
--enable-demuxer=flv \
--enable-demuxer=gif \
--enable-demuxer=aac \
--enable-demuxer=ogg \
--enable-demuxer=dts \
--enable-demuxer=mp3 \
--enable-demuxer=mov \
--enable-demuxer=m4v \
--enable-demuxer=concat \
--enable-demuxer=mpegts \
--enable-demuxer=mjpeg \
--enable-demuxer=mpegvideo \
--enable-demuxer=rawvideo \
--enable-demuxer=yuv4mpegpipe \
--enable-demuxer=rtp \
--enable-demuxer=rtsp \
--enable-demuxer=sdp \
--disable-parsers \
--enable-parser=aac \
--enable-parser=ac3 \
--enable-parser=h264 \
--enable-parser=mjpeg \
--enable-parser=png \
--enable-parser=bmp\
--enable-parser=mpegvideo \
--enable-parser=mpegaudio \
--disable-protocols \
--enable-protocol=file \
--enable-protocol=hls \
--enable-protocol=concat \
--enable-protocol=rtmp \
--enable-protocol=rtmpe \
--enable-protocol=rtmps \
--enable-protocol=rtmpt \
--enable-protocol=rtmpte \
--enable-protocol=rtmpts \
--enable-protocol=rtp \
--enable-protocol=udp \
--enable-protocol=tcp \
--disable-filters \
--enable-filter=aresample \
--enable-filter=asetpts \
--enable-filter=setpts \
--enable-filter=ass \
--enable-filter=scale \
--enable-filter=concat \
--enable-filter=atempo \
--enable-filter=movie \
--enable-filter=overlay \
--enable-filter=rotate \
--enable-filter=transpose \
--enable-filter=hflip \
--enable-zlib \
--disable-outdevs \
--disable-doc \
--disable-ffplay \
--disable-ffmpeg \
--disable-debug \
--disable-ffprobe \
--disable-postproc \
--disable-avdevice \
--disable-symver \
--disable-stripping \
--extra-cflags="-Os -fpic ${OPTIMIZE_CFLAGS}" \
--extra-ldflags="${ADDI_LDFLAGS}" \
${ADDITIONAL_CONFIGURE_FLAG}

make clean
make -j24
make install

# 合并到libffmpeg.so
${LD} \
-rpath-link=$NDK/platforms/android-$ANDROID_API/arch-arm/usr/lib \
-L$NDK/platforms/android-$ANDROID_API/arch-arm/usr/lib \
-L${PREFIX}/lib \
-L${X264_LIB} \
-L${FDK_AAC_LIB} \
-soname libffmpeg.so -shared -nostdlib -Bsymbolic --whole-archive --no-undefined -o \
${PREFIX}/libffmpeg.so \
libavcodec/libavcodec.a \
libavfilter/libavfilter.a \
libswresample/libswresample.a \
libavformat/libavformat.a \
libavutil/libavutil.a \
libswscale/libswscale.a \
${X264_LIB}/libx264.a \
${FDK_AAC_LIB}/libfdk-aac.a \
-lc -lm -lz -ldl -llog --dynamic-linker=/system/bin/linker \
${TOOLCHAIN}/lib/gcc/arm-linux-androideabi/4.9.x/libgcc_real.a

# strip 精简文件
$STRIP $PREFIX/libffmpeg.so
#回到根目录
cd ${ROOT_SOURCE}


