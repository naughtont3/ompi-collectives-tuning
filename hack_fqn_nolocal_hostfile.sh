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

if [ "x$LSB_DJOB_HOSTFILE" = "x" ] ; then
    echo "ERROR: Missing environment variable 'LSB_DJOB_HOSTFILE'"
    exit 1
fi

###
# XXX: Remove 1st line (batch-node) from list of compute nodes
# using 'tail +2' due to broken '--nolocal' (or :NOLOCAL) option.
###
# Setup FQDN hostfile for node-to-node ssh
export MY_FQDN_HOSTFILE=$BASE_DIR/fqdn-hostfile.$$
cat $LSB_DJOB_HOSTFILE |tail +2 | sed 's/$/.summit.olcf.ornl.gov/' > $MY_FQDN_HOSTFILE

