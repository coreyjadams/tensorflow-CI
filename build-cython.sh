#!/bin/bash -x

module swap PrgEnv-intel PrgEnv-gnu
source $BUILD_ROOT/env/bin/activate
export ENVIRON_BASE=$(dirname $(dirname $(which python)))

git clone https://github.com/cython/cython.git
cd cython
git checkout tags/0.25.2
CC=cc CXX=CC python setup.py build
CC=cc CXX=CC python setup.py install --prefix=$ENVIRON_BASE
cd -
