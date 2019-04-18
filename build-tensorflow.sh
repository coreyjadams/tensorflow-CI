#!/bin/bash -x

# Set up envirnoment:
module load $BASE_PYTHON
module swap PrgEnv-intel PrgEnv-gnu
module load gcc/7.3.0

module load java
export JAVA_VERSION=1.8


mkdir $BUILD_ROOT/tf_build; cd $BUILD_ROOT/tf_build;

# Activate the virtual env:
. $BUILD_ROOT/env/bin/activate
export ENVIRON_BASE=$(dirname $(dirname $(which python)))
which python
python --version


# Install tensorflow 1.13
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow
git checkout r1.13

# Have to add bazel to the path:
export PATH=$BUILD_ROOT/bazel_build/bazel-${BAZEL_VERSION}/output/:$PATH

./configure # you could choose the default options all the way.

ls $BUILD_ROOT/bazel_build/
ls $BUILD_ROOT/bazel_build/bazel-${BAZEL_VERSION}/
ls $BUILD_ROOT/bazel_build/bazel-${BAZEL_VERSION}/output/

$BUILD_ROOT/bazel_build/bazel-${BAZEL_VERSION}/output/bazel \
build \
--config=mkl -c opt --copt=-g --strip=never --copt='-Wl,rpath=/opt/gcc/7.3.0/snos' \
--copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-mavx512f --copt=-mavx512pf \
--copt=-mavx512cd --copt=-mavx512er --copt='-mtune=knl' --copt="-DEIGEN_USE_VML" \
//tensorflow/tools/pip_package:build_pip_package

## Other options one could try are: --copt=-fimf-use-svml

# The above step will take a long time (in the order of 1 hours), so be patient
# [7,717 / 7,718] Linking tensorflow/python/_pywrap_tensorflow_internal.so;
#
# Final message
#INFO: Elapsed time: 4137.835s, Critical Path: 3452.24s
#INFO: 6195 processes: 6195 local.
#INFO: Build completed successfully, 6550 total actions

# for version newer than 1.12, there will be compression error. To solve this
# pip install wheel --target $INSTALLDIR
# change the file $INSTALLDIR/wheel/wheelfile.py the following line to change compression to store
# from zipfile import ZipInfo, ZipFile, ZIP_STORED
# ZIP_DEFLATED=ZIP_STORED


bazel-bin/tensorflow/tools/pip_package/build_pip_package ./built_tf_wheel/

pip install --prefix=$ENVIRON_BASE --user ./built_tf_wheel/tensorflow-1.13.0-cp35-cp35m-linux_x86_64.whl