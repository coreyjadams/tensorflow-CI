#!/bin/bash -x
                
module load cray-python/3.6.1.1
mkdir -p $BUILD_ROOT
export PYTHONUSERBASE=$BUILD_ROOT/.pip/theta/cray-python
pip install --user virtualenv
virtualenv  --system-site-packages --no-wheel $BUILD_ROOT/env
