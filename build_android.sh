#!/bin/bash
export TMPDIR=/Users/zhufu/ffmpeg-3.0/ffmpegtemp #这句很重要，不然会报错 unable to create temporary file in
# NDK的路径，根据自己的安装位置进行设置
NDK=/Users/zhufu/android-ndk-r12b
# 编译针对的平台，可以根据自己的需求进行设置
# 这里选择最低支持android-14, arm架构，生成的so库是放在
# libs/armeabi文件夹下的，若针对x86架构，要选择arch-x86
PLATFORM=$NDK/platforms/android-14/arch-arm
# 工具链的路径，根据编译的平台不同而不同
# arm-linux-androideabi-4.9与上面设置的PLATFORM对应，4.9为工具的版本号，
# 根据自己安装的NDK版本来确定，一般使用最新的版本
TOOLCHAIN=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64
function build_one
{
./configure \
    --prefix=$PREFIX \
    --enable-shared \
    --enable-demuxer \
    --disable-static \
    --disable-programs \
    
    
    --disable-encoders \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-avfilter \
    --disable-swscale \
    --disable-muxers \
                
    --disable-devices \
    --disable-filters \
    --disable-parsers \

    --disable-doc \
    --disable-postproc \
    --disable-w32threads \
    --disable-avdevice \
    
    \
    --disable-everything \

    --enable-protocol=pipe \
    
    --enable-hwaccels \
    --enable-memalign-hack \

    --enable-asm \

    --enable-pthreads \
    --enable-network \

    \
    --enable-decoder=h264 \
    --enable-decoder=aac \
    \
    --enable-demuxer=flv \
    --enable-demuxer=mov \
    \
    --enable-protocol=rtmp \
    --enable-protocol=http \
    --enable-protocol=rtsp \
    \
    --disable-zlib \
    --disable-bzlib \

    --enable-pic \
    --disable-symver \
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
    --target-os=linux \
    --arch=arm \
    --enable-cross-compile \
    --sysroot=$PLATFORM \
    --extra-cflags="-I./include" \
$ADDITIONAL_CONFIGURE_FLAG
make clean
make
make install
}
# arm v7vfp
CPU=armv
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "
PREFIX=./android/$CPU-vfp
ADDITIONAL_CONFIGURE_FLAG=
build_one
# CPU=armv
# PREFIX=$(pwd)/android/$CPU
# ADDI_CFLAGS="-marm"
# build_one
#arm v6
#CPU=armv6
#OPTIMIZE_CFLAGS="-marm -march=$CPU"
#PREFIX=./android/$CPU 
#**********/=
#build_one
#arm v7vfpv3
# CPU=armv7-a
# OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfpv3-d16 -marm -march=$CPU "
# PREFIX=./android/$CPU
# ADDITIONAL_CONFIGURE_FLAG=
# build_one
#arm v7n
#CPU=armv7-a
#OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=neon -marm -march=$CPU -mtune=cortex-a8"
#PREFIX=./android/$CPU 
#ADDITIONAL_CONFIGURE_FLAG=--enable-neon
#build_one
#arm v6+vfp
#CPU=armv6
#OPTIMIZE_CFLAGS="-DCMP_HAVE_VFP -mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU"
#PREFIX=./android/${CPU}_vfp 
#ADDITIONAL_CONFIGURE_FLAG=
#build_one