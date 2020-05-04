#!/usr/bin/env python
# Copyright (c) 2020      Amazon.com, Inc. or its affiliates.  All Rights
#                         reserved.
# Copyright (c) 2020      UT-Battelle, LLC. All rights reserved.
#
# $COPYRIGHT$
#
# Additional copyrights may follow
#
# $HEADER$
#

import os
import sys

imb_collectives = ["reduce_scatter_block"]

def main():
    from os import system
    from sys import argv
    from common import Params
    import sys

    dir_path = os.path.dirname(os.path.realpath(__file__))
    config = Params( argv[1] )
    scheduler = argv[2]
    collective_list = config.getStrlst("collectives")
    omb_path = config.getStr("omb_collective_directory")
    imb_bin = config.getStr("imb_binary")
    num_rank_list = config.getIntlst("number_of_ranks")
    max_num_node = config.getInt("max_num_node")
    num_core_per_node = config.getInt("number_of_cores_per_node")
    num_run = config.getInt("number_of_runs_per_test")

    job_directory = dir_path+"/collective_jobs"
    for collective in collective_list:
        params = Params( job_directory+"/"+collective+".job" )

        if not os.path.exists(dir_path+"/output"):
            os.makedirs(dir_path+"/output")
        if not os.path.exists(dir_path+"/output/"+collective):
            os.makedirs(dir_path+"/output/"+collective)

        num_alg = params.getInt("number_of_algorithms")
        exclude_alg = params.getIntlst("exclude_algorithms")
        two_proc_alg = -1
        try:
            two_proc_alg = params.getInt("two_proc_alg")
        except Exception as e:
            print "No two proc algorithm for "+collective

        f = open(dir_path+"/output/"+collective+"/"+collective+"_coltune.sh", "w")
        print >> f, "#!/bin/sh"
        print >> f, "#"
        if scheduler == "slurm":
            print >> f, "#SBATCH --job-name="+collective
            print >> f, "#SBATCH --output=res.txt"
            print >> f, "#"
            print >> f, "#SBATCH --ntasks-per-node="+str(num_core_per_node)
            print >> f, "#SBATCH --time=1000:00:00"
            print >> f, "#SBATCH --nodes="+str(max_num_node)
        elif scheduler == "lsf":
            # TJN: Using mpirun for mapping b/c we allocate all of node w/ LSF
            print >> f, "#BSUB   -J "+collective
            print >> f, "#BSUB   -o res.txt.%J"
            print >> f, "#BSUB   -e res.txt.%J"
            print >> f, "#BSUB   -W 2:00"
            print >> f, "#BSUB   -nnodes "+str(max_num_node)
        elif scheduler == "sge":
            print >> f, "#$ -j y"
            print >> f, "#$ -pe mpi %d" % (max_num_node * num_core_per_node)
            print >> f, "#"
            print >> f, "#$ -cwd"
            print >> f, "#"
            print >> f, "echo Got $NSOLTS processors."
        else:
            print "Unknown scheduler. Aborting.."
            sys.exit()

        print >> f, ""

        # TJN: Add our modules/environment setup
        print >> f, "module unload spectrum-mpi xalt darshan-runtime"
        print >> f, "module load gcc/6.4.0"
        print >> f, "module load cuda/10.1.243"

        # TJN: On PEAK we use DEVELOP area and 'openmpi/master_tjn'
        #      On SUMMIT we would use (PROD) and 'openmpi/master'
        # PEAK
        print >> f, "module use /sw/summit/ums/ompix/DEVELOP/gcc/6.4.0/modules"
        print >> f, "module load ucx/1.7.0"
        print >> f, "module load openmpi/master_tjn"
        # SUMMIT
        #print >> f, "module use /sw/summit/ums/ompix/gcc/6.4.0/modules"
        #print >> f, "module load ucx/1.7.0"
        #print >> f, "module load openmpi/master"

        print >> f, ""

        print >> f, "# TJN: HACK avoid problems with broken --nolocal/:NOLOCAL"
        print >> f, "export MY_HOSTFILE=/tmp/my-hostfile.$$"
        print >> f, "/gpfs/alpine/stf010/proj-shared/naughton/peak/ompix/perf-colltune/ompi-collectives-tuning/hack_fqn_nolocal_hostfile.sh $LSB_DJOB_HOSTFILE  $MY_HOSTFILE"

        print >> f, ""

        for num_rank in num_rank_list:
            for alg in range(num_alg+1):
                if alg in exclude_alg or (alg == two_proc_alg and num_rank > 2):
                    continue
                print >> f, "# ", alg, num_rank, "ranks"
                for run_id in xrange(num_run):
                    if collective in imb_collectives:
                        prg_name = imb_bin+" -npmin %d %s " % (num_rank, collective)
                    else:
                        prg_name = omb_path+"/osu_"+collective
                    cmd = "mpirun --np %d " % (num_rank)
                    #cmd += "--hostfile $LSB_DJOB_HOSTFILE --nolocal "
                    cmd += "--hostfile $MY_HOSTFILE "
                    cmd += "--map-by ppr:" + str(num_core_per_node) + ":node --map-by core "
                    cmd += "--mca coll_tuned_use_dynamic_rules 1 --mca coll_tuned_"+collective+"_algorithm "+str(alg)
                    cmd += " " + prg_name
                    cmd += " >& " + dir_path+"/output/"+collective + "/" + str(alg) + "_" + str(num_rank) + "ranks" + "_run" + str(run_id) + ".out"
                    print >> f, cmd
                print >> f, ""

        print >> f, ""

        print >> f, "# TJN: HACK avoid problems with broken --nolocal/:NOLOCAL"
        print >> f, "rm -f $MY_HOSTFILE"

        print >> f, ""

        f.close()
        print "SGE script wrote to "+collective+"_coltune.sh successfully!"

if __name__ == "__main__":
    main()

