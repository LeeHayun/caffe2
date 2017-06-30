#!/bin/bash
##############################################################################
# Example command to build the android target.
##############################################################################
# 
# This script shows how one can build a Caffe2 binary for artik 10. The build
# is essentially much similar to a host build, with one additional change
# which is to specify -mfpu=neon for optimized speed.

CAFFE2_ROOT="$( cd "$(dirname -- "$0")"/.. ; pwd -P)"
echo "Caffe2 codebase root is: $CAFFE2_ROOT"
BUILD_ROOT=$CAFFE2_ROOT/build
mkdir -p $BUILD_ROOT
echo "Build Caffe2 ARTIK into: $BUILD_ROOT"

# obtain dependencies.
echo "Installing dependencies."
dnf install \
  cmake \
  gflags-devel \
  glog-devel \
  protobuf-devel \
  python-devel \
  python-pip \
  numpy \
  protobuf-compiler \
  protobuf-python
# python dependencies
pip install hypothesis

# Now, actually build the android target.
echo "Building caffe2"
cd $BUILD_ROOT

# Note: you can add more dependencies above if you need libraries such as
# leveldb, lmdb, etc.
cmake .. \
    -DCMAKE_VERBOSE_MAKEFILE=1 \
    -DCAFFE2_CPU_FLAGS="-mfpu=neon -mfloat-abi=hard" \
    || exit 1

# Note: while ARTIK 10 has 8 cores, running too many builds in parallel may
# cause out of memory errors so we will simply run -j 4 only.
make -j 4 || exit 1
