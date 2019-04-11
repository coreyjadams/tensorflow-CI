#!/bin/bash -x

mpi_launch="aprun"
BUILD_ROOT=$(cat BUILD_ROOT.path)
. $BUILD_ROOT/env/bin/activate
which python
python --version

$mpi_launch -n 2 $BUILD_ROOT/env/bin/python printRank.py >& printRank.out
status=$?
if [ $status -ne 0 ]; then
    cat printRank.out
    exit $status
fi

if grep -q "rank 0" printRank.out && grep -q "rank 1" printRank.out;
then
    echo "Success: aprun -n2 gave rank0 and rank1"
    touch $COBALT_JOBID.finished
else
    echo "Failed: aprun -n2 gave the following output:"
    cat printRank.out
    touch $COBALT_JOBID.finished
    exit 1
fi
