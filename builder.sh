#!/usr/bin/env sh

docker build -t builder .

mkdir -p libs

id=$(docker create builder)
docker cp "$id":/flac/src/libFLAC/.libs/libFLAC.so ./libs/
docker cp "$id":/libvpx/vpx-vp8-vp9-nodocs-x86_64-linux-v1.11.0/lib/libvpx.so ./libs/
docker cp "$id":/eduke32-csrefactor/netduke32 .
docker rm -v "$id"
