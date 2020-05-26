#!/bin/bash

bsub -P STF010 ./output/alltoall/alltoall_coltune.sh

bwait -w "ended(alltoall)"

python coltune_analyze.py example/config.peak.pr7730

echo "Finished ROUND2.pr7730 runs on PEAK" | mailx -s "PEAK - ROUND2.pr7730 coltune tests done" 3t4@ornl.gov
