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


wget https://github.com/bazelbuild/bazel/releases/download/0.16.0/bazel-0.16.0-dist.zip
mkdir bazel-0.16.0
cd bazel-0.16.0
mv ../bazel-0.16.0-dist.zip ./
unzip bazel-0.16.0-dist.zip
bash ./compile.sh
cd ../

cd ../
echo "Current files:"
ls




