#!/bin/bash

if [ -z "$ANDROID_NDK" -a "$ANDROID_NDK" == "" ]; then
    echo -e "\033[31mFailed! ANDROID_NDK is empty. Run 'export ANDROID_NDK=[PATH_TO_NDK]'\033[0m"
    exit 1
fi

CURRENT_DIR=`pwd`
if [ -d "$CURRENT_DIR/src/main/jni" ]; then
  CURRENT_DIR="$CURRENT_DIR/src/main/jni"
fi
BUILD_DIR=${CURRENT_DIR}/ffmpeg
FFMPEG_EXT_PATH=$CURRENT_DIR/..
NDK_PATH=$ANDROID_NDK
HOST_PLATFORM=
ENABLED_DECODERS=(vorbis opus aac h263 h264 hevc)

FFMPEG_VERSION="4.3.1"
FF_SOURCE_DIR=$CURRENT_DIR/ffmpeg-${FFMPEG_VERSION}

if [ ! -e "ffmpeg-${FFMPEG_VERSION}.tar.bz2" ]; then
    echo "Downloading ffmpeg-${FFMPEG_VERSION}.tar.bz2"
    curl -LO http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2
else
    echo "Using ffmpeg-${FFMPEG_VERSION}.tar.bz2"
fi

if [ "$1" == "--force" -o -d "$BUILD_DIR/android-libs" ]; then
  echo "ffmpeg has already built. Exiting..."
  exit 0
fi

rm -rf $BUILD_DIR 
tar -xf ffmpeg-${FFMPEG_VERSION}.tar.bz2 && mv ffmpeg-${FFMPEG_VERSION} ffmpeg && echo "ffmpeg-${FFMPEG_VERSION}.tar.bz2 has been extracted"

# cd "${FFMPEG_EXT_PATH}/jni" && \
# git clone git://source.ffmpeg.org/ffmpeg ffmpeg
# 
# cd "${FFMPEG_EXT_PATH}/jni/ffmpeg" && \
# git checkout release/${FFMPEG_VERSION}

function setCurrentPlatform {
  UNAME_S=$(uname -s)
  case "$UNAME_S" in
      Darwin)
          export FF_MAKE_FLAGS="-j`sysctl -n machdep.cpu.core_count`"
          export HOST_PLATFORM=darwin-x86_64
      ;;
      Linux*)
          export FF_MAKE_FLAGS="-j$(nproc)"
          export HOST_PLATFORM=linux-x86_64
          ;;
      CYGWIN_NT-*)
          export HOST_PLATFORM=linux-x86_64
          FF_WIN_TEMP="$(cygpath -am /tmp)"
          export FF_MAKE_FLAGS="-j2"
          export TEMPDIR=$FF_WIN_TEMP/
          echo "Cygwin temp prefix=$FF_WIN_TEMP/"
      ;;
      *)
          export HOST_PLATFORM=linux-x86_64
          export FF_MAKE_FLAGS="-j1"
          echo -e "\033[33mWarning! Unknown platform ${UNAME_S}! falling back compile linux-x86_64\033[0m"
          ;;
  esac
    echo "build platform: ${HOST_PLATFORM}"
    echo "FF_MAKE_FLAGS: ${FF_MAKE_FLAGS}"
}

setCurrentPlatform

cd "${FFMPEG_EXT_PATH}/jni" && \
./build_ffmpeg.sh \
  "${FFMPEG_EXT_PATH}" "${NDK_PATH}" "${HOST_PLATFORM}" "$FF_MAKE_FLAGS" "${ENABLED_DECODERS[@]}"