SUMMARY
------

 - UPDATE: 2020.05.08 Use 'PEAK.coltune.tar.gz'  That has full dataset for
   tests on PEAK and similar note as this for setup details.


README
------

 - System: "PEAK" (summit devel system)
 - Date: 2020.05.04
 - UPDATE: 2020.05.05 -- "round2" rerun of select items that had errors, see
                         Notes area at end of this file for further details.
 - UPDATE: 2020.05.07 -- "round3" rerun of a few from "round2" that did not
                         complete.  See Notes are for further details.

Software Versions
----------------
 - Open MPI master @ 4318d41
    ```
        [naughton@login1.peak openmpi-br-master-tjn]$ git submodule status
         4a43c39c89037f52b4e25927e58caf08f3707c33 opal/mca/hwloc/hwloc2/hwloc (hwloc-2.1.0rc2-53-g4a43c39)
         8de5cade7be10b054c0a1e53fba20d207333a279 opal/mca/pmix/pmix4x/openpmix (v1.1.3-2357-g8de5cad)
         cf8f7e61e2a084c9bc9df4fb25bb4933ccf02857 prrte (dev-30528-gcf8f7e6)
        [naughton@login1.peak openmpi-br-master-tjn]$
    ```

   Excerpt from `ompi_info -c` output:
    ```
      Configure command line: '--enable-prte-prefix-by-default' '--prefix=/sw/summit/ums/ompix/DEVELOP/gcc/6.4.0/install/openmpi-br-master-tjn' '--disable-vt' '--enable-mpi1-compatibility' '--with-memory-manager=none' '--with-ucx=/sw/summit/ums/ompix/DEVELOP/gcc/6.4.0/install/ucx-1.7.0' '--with-cuda=/sw/peak/cuda/10.1.243' '--with-knem=/opt/knem-1.1.3.90mlnx1'
    ```

 - UCX release 1.7.0
    ```
     # UCT version=1.7.0 revision 9d06c3a
     # configured with: --prefix=/sw/summit/ums/ompix/gcc/6.4.0/install/ucx-1.7.0 --disable-debug --disable-assertions --disable-params-check --enable-mt --with-gdrcopy=/sw/summit/gdrcopy/2.0 --with-cuda=/sw/summit/cuda/10.1.243 --with-knem=/opt/knem-1.1.3.90mlnx1
    ```

 - OMPI Collectives Tune `tjn-peak` branch
    - https://github.com/naughtont3/ompi-collectives-tuning.git

 - All using GCC toolchain (`gcc/6.4.0` module)
    ```
     Currently Loaded Modules:
      1) hsi/5.0.2.p5    3) DefApps     5) cuda/10.1.243   7) openmpi/master_tjn
      2) lsf-tools/2.0   4) gcc/6.4.0   6) ucx/1.7.0
    ```


Other Notes
-----------
 - NOTE: Added some `--map-by` and `--bind-to` command line options to control
   launch b/c we use hostfile launcher.
 - NOTE: Had to add hack to avoid service node in hostfile due to bug
   that yeilds `--nolocal` (or `:NOLOCAL`) ineffective
 - NOTE: Added new `--with-lsf` option and few hardcodes for accounts,
   all captured in the `tjn-peak` branch of ompi-collectives-tuning fork
 - NOTE: Added couple default environment variables for MCA and UCX

    ```
      [naughton@login1.peak openmpi-br-master-tjn]$ env | grep MCA
      PRRTE_MCA_rmaps_base_no_schedule_local=1
      PRRTE_MCA_routed=direct
      OMPI_MCA_io=romio321

      [naughton@login1.peak openmpi-br-master-tjn]$ env | grep UCX
      UCX_DIR=/sw/summit/ums/ompix/gcc/6.4.0/install/ucx-1.7.0
      UCX_INSTALL_DIR=/sw/summit/ums/ompix/gcc/6.4.0/install/ucx-1.7.0
      UCX_MAX_RNDV_RAILS=2
      UCX_NET_DEVICES=mlx5_0:1,mlx5_3:1
    ```

 - NOTE: "round2" There were several cases that failed on the inital runs,
   most look to be due to lack of walltime.  So I am resubmitting that
   subset based on a revised set of run config files,
    - examples/config.peak.round2-allgather
    - examples/config.peak.round2-allgatherv-alltoall
    - examples/config.peak.round2-reduce_scatter_block

   This relates to errors for the following items in the 2020.05.04 data
   tarball.
     - allgather
        - ran out of time it appears at/after 0_128ranks_run0.out
     - allgatherv
        - ran out of time it appears at/after 1_512ranks_run2.out
     - alltoall
        - ran out of time it appears at/after 1_512ranks_run0.out
     - reduce_scatter_block
        - all seem to fail w/ some library path/error?

 - NOTE: "round3" There were still a view runs that did not complete in time
   during the "round2" re-test.  I am submitting **just** that subset
   and will add them to the other results from "round3".
   I will just hack the run script and resubmit this limited set of jobs.

   This relates to the following, which will be rerun in "round3":
    - allgatherv
        - 4_512ranks_run1.out
        - 4_512ranks_run2.out

    - alltoall
        - 3_512ranks_run2.out
        - 4_512ranks_run0.out
        - 4_512ranks_run1.out
        - 4_512ranks_run2.out

    I will likely just skip 'reduce_scatter_block' for now, b/c
    all of of the tests failed again, but for some compile/lib reason.

   The "round3" (2020.05.07-PEAK-round3.output.tar.gz) data
   is for a few dangling items from round2.  So these few files
   should be added to the round2 data output to have a full
   set of data for the given config files.


Acks for Systems/Projects
-------------------------
 - This research used resources of the Oak Ridge Leadership Computing
   Facility at the Oak Ridge National Laboratory, which is supported by the
   Office of Science of the U.S. Department of Energy under Contract No.
   DE-AC05-00OR22725.

 - This research was supported by the Exascale Computing Project
   (17-SC-20-SC), a collaborative effort of the U.S. Department of Energy
   Office of Science and the National Nuclear Security Administration.

