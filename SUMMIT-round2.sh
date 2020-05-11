#!/bin/bash

####
# TJN: The "ERROR" items were actually not supposed
#      to be resubmitted, thus the "IGNORE" marker.
#      It appears they passed the first time and no
#      need for a "Round2" resubmit.  The error was
#      that I tried to run a script that did not
#      exist (b/c I had already run it and did not restage.)
#
#      The "DONE" just indicates the tests that did
#      run during the "Round2" resubmit.
####

set -x #echo on

# DONE
bsub -P STF010 ./output/allgather/allgather_coltune.sh
bwait -w "ended(allgather)"

# DONE
bsub -P STF010 ./output/allgatherv/allgatherv_coltune.sh
bwait -w "ended(allgatherv)"

#IGNORE # ERROR
bsub -P STF010 ./output/allreduce/allreduce_coltune.sh
bwait -w "ended(allreduce)"

# DONE
bsub -P STF010 ./output/alltoall/alltoall_coltune.sh
bwait -w "ended(alltoall)"

# DONE
bsub -P STF010 ./output/alltoallv/alltoallv_coltune.sh
bwait -w "ended(alltoallv)"

#IGNORE # ERROR
bsub -P STF010 ./output/barrier/barrier_coltune.sh
bwait -w "ended(barrier)"

#IGNORE # ERROR
bsub -P STF010 ./output/bcast/bcast_coltune.sh
bwait -w "ended(bcast)"

#IGNORE # ERROR
bsub -P STF010 ./output/gather/gather_coltune.sh
bwait -w "ended(gather)"

#IGNORE # ERROR
bsub -P STF010 ./output/reduce/reduce_coltune.sh
bwait -w "ended(reduce)"

#IGNORE # ERROR
bsub -P STF010 ./output/reduce_scatter/reduce_scatter_coltune.sh
bwait -w "ended(reduce_scatter)"

#IGNORE # ERROR
bsub -P STF010 ./output/scatter/scatter_coltune.sh
bwait -w "ended(scatter)"

# DONE
bsub -P STF010 ./output/reduce_scatter_block/reduce_scatter_block_coltune.sh
bwait -w "ended(reduce_scatter_block)"


python coltune_analyze.py example/config.summit.ppn42

echo "Finished ROUND2 runs on SUMMIT" | mailx -s "SUMMIT - ROUND2 coltune tests done" 3t4@ornl.gov

