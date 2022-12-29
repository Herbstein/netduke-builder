FROM debian:latest

## Prepare package installation
RUN apt-get update

## General build dependencies 
RUN apt-get install -y git make gcc pkg-config g++ nasm wget autoconf gettext libtool libtool-bin

# libFLAC

RUN git clone https://github.com/xiph/flac --branch 1.3.0 --depth 1

WORKDIR /flac

RUN ./autogen.sh --no-symlinks
RUN ./configure
RUN make -j$(nproc)
RUN make install

WORKDIR /

# libvpx

## get libvpx sources
RUN git clone https://github.com/webmproject/libvpx/ --branch v1.10.0 --depth 1

WORKDIR /libvpx

## build and collect libvpx files
RUN ./configure --disable-examples --disable-tools --disable-docs --disable-unit-tests --enable-shared
RUN make -j$(nproc)
RUN make dist
RUN make install

WORKDIR /

# netduke32

## Get Netduke32 sources
RUN git clone https://voidpoint.io/StrikerTheHedgefox/eduke32-csrefactor --branch netduke32_main --depth 1

## Specific Netduke32 dependencies
RUN apt-get install -y libsdl2-dev

## Stay in Netduke directory when building
WORKDIR /eduke32-csrefactor

ENV CPATH="../libvpx/vpx-vp8-vp9-nodocs-x86_64-linux-v1.10.0/include:../flac/include"

RUN make netduke32 -j$(nproc)

WORKDIR /
