#!/bin/bash -x
                
module load cray-python/3.6.1.1
rm -rf $BUILD_ROOT
rm -rf ./cython
rm -rf ./mpi4py
mkdir -p $BUILD_ROOT
export PYTHONUSERBASE=$BUILD_ROOT/.pip/theta/cray-python
pip install --user virtualenv
$PYTHONUSERBASE/bin/virtualenv  --system-site-packages --no-wheel $BUILD_ROOT/env
which python
python --version
