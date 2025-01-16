#!/bin/bash
## Ref
## https://github.com/hbiyik/FFmpeg

## Dependencies
export DEBIAN_FRONTEND=noninteractive
apt update
apt install -y \
  wget \
  autoconf automake \
  libtool \
  diffutils \
  cmake meson \
  git \
  texinfo \
  yasm nasm \
  build-essential \
  ninja-build \
  pkg-config \
  zlib1g-dev \
  bzip2 \
  alsa-base libasound2-dev \
  libdrm-dev \
  libfdk-aac-dev

## Install deb packages dependencies
apt install -y \
  devscripts \
  debhelper \
  dh-make \
  dh-exec \
  rsync \
  vim \
  libavcodec-extra \
  libjs-bootstrap \
  checkinstall

## Build libyuv
cd /opt
git clone https://chromium.googlesource.com/libyuv/libyuv/
cd libyuv
cmake \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON
make -j$(nproc) 
make install

## Gen deb package
mkdir -p libyuv-dev/usr/bin libyuv-dev/usr/lib libyuv-dev/usr/include
cp /usr/bin/yuvconvert libyuv-dev/usr/bin/
cp /usr/lib/libyuv.* libyuv-dev/usr/lib/
cp -r /usr/include/libyuv libyuv-dev/usr/include/
mkdir libyuv-dev/DEBIAN

cat <<EOF | tee libyuv-dev/DEBIAN/control
Package: libyuv
Version: 1.0
Section: libs
Priority: optional
Architecture: armhf
Maintainer: Seu Nome <seuemail@exemplo.com>
Description: Biblioteca YUV para conversão de formatos de vídeo.
EOF

dpkg-deb --build libyuv-dev

## install packages
dpkg -i libyuv-dev.deb