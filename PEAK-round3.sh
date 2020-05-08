#!/bin/bash

bsub -P STF010 ./output/allgatherv/allgatherv_coltune.sh
bwait -w "ended(allgatherv)"

bsub -P STF010 ./output/alltoall/alltoall_coltune.sh
bwait -w "ended(alltoall)"

python coltune_analyze.py example/config.peak.round2-allgatherv-alltoall

echo "Finished ROUND3 runs on PEAK" | mailx -s "PEAK - ROUND3 coltune tests done" 3t4@ornl.gov
