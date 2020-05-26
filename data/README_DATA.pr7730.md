SUMMARY
------
 - UPDATE: 2020.05.26 Rerun w/ PR #7730 (and correct ompi module :-))

README
------

 - System: "PEAK" (summit devel system)
 - Date: 2020.05.20
 - UPDATE: 2020.05.26 Rerun with PR #7730. (this will be "pr7730" and later
   reruns will be "pr7730.roundX".

Software Versions
----------------
 - Open MPI master @ 4318d41
    ```
        [naughton@login1.peak openmpi-br-master-pr7730]$ git describe ; git submodule
        v2.x-dev-7803-g07a08bf
         4a43c39c89037f52b4e25927e58caf08f3707c33 opal/mca/hwloc/hwloc2/hwloc (hwloc-2.1.0rc2-53-g4a43c39)
         ad669dfb222df0d12de18e69a8ba1dbe8f39d2cf opal/mca/pmix/pmix4x/openpmix (v1.1.3-2393-gad669df)
         37478db8c4d38b4790013c4ea274b8938d3006d5 prrte (dev-30593-g37478db)
        [naughton@login1.peak openmpi-br-master-pr7730]$
    ```

   Excerpt from `ompi_info -c` output:
    ```
       Configure command line: '--enable-prte-prefix-by-default' '--prefix=/sw/summit
/ums/ompix/DEVELOP/gcc/6.4.0/install/openmpi-br-master-pr7730' '--disable-vt' '-
-enable-mpi1-compatibility' '--with-memory-manager=none' '--with-ucx=/sw/summit/
ums/ompix/DEVELOP/gcc/6.4.0/install/ucx-1.7.0' '--with-cuda=/sw/peak/cuda/10.1.2
43' '--with-knem=/opt/knem-1.1.3.90mlnx1' '--disable-man-pages'
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
          1) hsi/5.0.2.p5    4) gcc/6.4.0       7) openmpi/master_pr7730
          2) lsf-tools/2.0   5) cuda/10.1.243
          3) DefApps         6) ucx/1.7.0
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
        [naughton@login1.peak data]$ env | grep MCA
        PRRTE_MCA_rmaps_base_no_schedule_local=1
        PRRTE_MCA_routed=direct
        OMPI_MCA_io=romio321

        [naughton@login1.peak data]$ env | grep UCX
        UCX_DIR=/sw/summit/ums/ompix/DEVELOP/gcc/6.4.0/install/ucx-1.7.0
        UCX_INSTALL_DIR=/sw/summit/ums/ompix/DEVELOP/gcc/6.4.0/install/ucx-1.7.0
        UCX_MAX_RNDV_RAILS=2
        UCX_NET_DEVICES=mlx5_0:1,mlx5_3:1
    ```

 - NOTE: Using `openmpi/master_pr7730`.  Had to adjust gen script
   (`coltune_script.py`) to source this module when running tests.

    ```
     module load openmpi/master_pr7730
    ```

Acks for Systems/Projects
-------------------------
 - This research used resources of the Oak Ridge Leadership Computing
   Facility at the Oak Ridge National Laboratory, which is supported by the
   Office of Science of the U.S. Department of Energy under Contract No.
   DE-AC05-00OR22725.

 - This research was supported by the Exascale Computing Project
   (17-SC-20-SC), a collaborative effort of the U.S. Department of Energy
   Office of Science and the National Nuclear Security Administration.

