#!/bin/bash
#
# TJN: Quick hack to avoid problems with mismatch of resources
# due to trying to run on service/batch nodes that appear in LSF
# HOSTFILE. The problem is that the OMPI '--nolocal' (or :NOLOCAL)
# option is not working and this causes things to try and use non-compute
# node in hostfile.  Grrrrr...
#
# We go ahead and add the FQDN stuff to ensure we do not have any problems
# with the node-to-node SSH'ing.  Was problem in past, but may be fixed now.
#
# Usage:
#    ./script  IN_HOSTFILE  OUT_HOSTFILE
###

INFILE=$1
OUTFILE=$2

if [ ! -f "$INFILE" ] ; then
    echo "ERROR: Missing arg input file '$INFILE'"
    exit 1
fi

if [ "x$OUTFILE" = "x" ] ; then
    echo "ERROR: Missing arg output file '$OUTFILE'"
    exit 1
fi

###
# XXX: Remove 1st line (batch-node) from list of compute nodes
# using tail due to broken '--nolocal' (or :NOLOCAL) option.
###
nlines=$(wc -l $INFILE | awk '{print $1}')
keep_nlines=$(expr $nlines - 1)
cat $INFILE |tail -$keep_nlines | sed 's/$/.summit.olcf.ornl.gov/' > $OUTFILE

