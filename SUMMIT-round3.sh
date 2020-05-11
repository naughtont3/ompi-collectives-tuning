#!/bin/bash

set -x #echo on

# TODO (restart at 1_1024ranks_run1.out)
bsub -P STF010 ./output/allgatherv/allgatherv_coltune.sh
bwait -w "ended(allgatherv)"

# TODO (restart at 3_1024ranks_run0.out)
bsub -P STF010 ./output/alltoall/alltoall_coltune.sh
bwait -w "ended(alltoall)"

# TODO (restart at 1_2048ranks_run0.out)
bsub -P STF010 ./output/alltoallv/alltoallv_coltune.sh
bwait -w "ended(alltoallv)"

# TODO
bsub -P STF010 ./output/reduce_scatter_block/reduce_scatter_block_coltune.sh
bwait -w "ended(reduce_scatter_block)"


python coltune_analyze.py example/config.summit.ppn42

echo "Finished ROUND3 runs on SUMMIT" | mailx -s "SUMMIT - ROUND3 coltune tests done" 3t4@ornl.gov

