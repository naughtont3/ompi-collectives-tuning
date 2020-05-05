#!/bin/bash

config_files="example/config.peak.round2-allgather
             example/config.peak.round2-allgatherv-alltoall
             example/config.peak.round2-reduce_scatter_block"

for cfgfile in $config_files ; do
    echo "#-------------------------------"
    echo "# Round2: $cfgfile"
    echo "#"
    echo "# CMD: ./run_and_analyze.sh -c $cfgfile --with-lsf"
    echo "#-------------------------------"
    ./run_and_analyze.sh -c $cfgfile --with-lsf

done

echo "Finished runs on PEAK" | mailx -s "PEAK - coltune tests done" 3t4@ornl.gov
