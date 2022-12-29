FROM debian:latest

## Prepare package installation
RUN apt-get update

## General build dependencies
RUN apt-get install -y git make gcc pkg-config g++ nasm

# libFLAC

## Specific libFLAC dependencies
RUN apt-get install -y autoconf automake gettext libtool-bin

RUN git clone https://github.com/xiph/flac --branch 1.3.4 --depth 1
RUN cd flac\
    && ./autogen.sh --no-symlinks\
    && ./configure\
    && make\
    && make install

# libvpx

## get libvpx sources
RUN git clone https://github.com/webmproject/libvpx/ --branch v1.11.0 --depth 1

## build and collect libvpx files
RUN cd libvpx\
    && ./configure --disable-examples --disable-tools --disable-docs --disable-unit-tests --enable-shared\
    && make -j$(nproc)\
    && make dist\
    && make install

# netduke32

## Get Netduke32 sources
RUN git clone https://voidpoint.io/StrikerTheHedgefox/eduke32-csrefactor --branch oldmp_porting --depth 1

## Specific Netduke32 dependencies
RUN apt-get install -y libsdl2-dev

## Stay in Netduke directory when building
WORKDIR /eduke32-csrefactor

RUN git checkout oldmp_porting

RUN CPATH="../libvpx/vpx-vp8-vp9-nodocs-x86_64-linux-v1.11.0/include:../flac/include"\
    make oldmp -j$(nproc)

WORKDIR /
