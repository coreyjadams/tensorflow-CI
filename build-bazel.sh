#!/bin/bash -x

# Set up envirnoment:
module load $BASE_PYTHON
module swap PrgEnv-intel PrgEnv-gnu
module load java
export JAVA_VERSION=1.8

. $BUILD_ROOT/env/bin/activate
export ENVIRON_BASE=$(dirname $(dirname $(which python)))
which python
python --version

mkdir $BUILD_ROOT/bazel_build; cd $BUILD_ROOT/bazel_build;


wget https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-dist.zip
mkdir bazel-${BAZEL_VERSION}
cd bazel-${BAZEL_VERSION}
mv ../bazel-${BAZEL_VERSION}-dist.zip ./
unzip bazel-${BAZEL_VERSION}-dist.zip
bash ./compile.sh
cd ../

cd ../
echo "Current files:"
ls




