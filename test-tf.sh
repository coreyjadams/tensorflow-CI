#!/bin/bash -x

mpi_launch="aprun"
BUILD_ROOT=$(cat BUILD_ROOT.path)
. $BUILD_ROOT/env/bin/activate
which python
python --version

$mpi_launch -n 1 $BUILD_ROOT/env/bin/python simple_tf_session.py >& simple_tf_session.out
status=$?
if [ $status -ne 0 ]; then
    cat simple_tf_session.out
    exit $status
fi

if grep -q "Success: tensorflow session succeeded" simple_tf_session.out;
then
    echo "Success: tensorflow session succeeded."
    touch $COBALT_JOBID.finished
else
    echo "Failed: aprun -n2 gave the following output:"
    cat simple_tf_session.out
    touch $COBALT_JOBID.finished
    exit 1
fi
