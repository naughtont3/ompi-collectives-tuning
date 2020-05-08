#!/bin/bash

set -x #echo on

bsub -P STF010 ./output/allgather/allgather_coltune.sh
bwait -w "ended(allgather)"

bsub -P STF010 ./output/allgatherv/allgatherv_coltune.sh
bwait -w "ended(allgatherv)"

bsub -P STF010 ./output/allreduce/allreduce_coltune.sh
bwait -w "ended(allreduce)"

bsub -P STF010 ./output/alltoall/alltoall_coltune.sh
bwait -w "ended(alltoall)"

bsub -P STF010 ./output/alltoallv/alltoallv_coltune.sh
bwait -w "ended(alltoallv)"

bsub -P STF010 ./output/barrier/barrier_coltune.sh
bwait -w "ended(barrier)"

bsub -P STF010 ./output/bcast/bcast_coltune.sh
bwait -w "ended(bcast)"

bsub -P STF010 ./output/gather/gather_coltune.sh
bwait -w "ended(gather)"

bsub -P STF010 ./output/reduce/reduce_coltune.sh
bwait -w "ended(reduce)"

bsub -P STF010 ./output/reduce_scatter/reduce_scatter_coltune.sh
bwait -w "ended(reduce_scatter)"

bsub -P STF010 ./output/scatter/scatter_coltune.sh
bwait -w "ended(scatter)"

bsub -P STF010 ./output/reduce_scatter_block/reduce_scatter_block_coltune.sh
bwait -w "ended(reduce_scatter_block)"


python coltune_analyze.py example/config.summit.ppn42

echo "Finished ROUND2 runs on SUMMIT" | mailx -s "SUMMIT - ROUND2 coltune tests done" 3t4@ornl.gov

