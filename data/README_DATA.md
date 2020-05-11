README
------

 - System: "Summit"
 - Date: 2020.05.05
 - UPDATE: 2020.05.08 - TJN:  "round2" rerun of select items that had
        errors, see Notes area at end of this file for further details.

Software Versions
----------------
 - Open MPI master @ 4318d41
    ```
     login1:$ git submodule status
      4a43c39c89037f52b4e25927e58caf08f3707c33 opal/mca/hwloc/hwloc2/hwloc (hwloc-2.1.0rc2-53-g4a43c39)
      8de5cade7be10b054c0a1e53fba20d207333a279 opal/mca/pmix/pmix4x/openpmix (v1.1.3-2357-g8de5cad)
      cf8f7e61e2a084c9bc9df4fb25bb4933ccf02857 prrte (dev-30528-gcf8f7e6)
     login1:$
    ```

   Excerpt from `ompi_info -c` output:
    ```
     Configure command line: '--enable-prte-prefix-by-default' '--prefix=/sw/summit/ums/ompix/gcc/6.4.0/install/openmpi-br-master' '--disable-vt' '--enable-mpi1-compatibility' '--with-memory-manager=none' '--with-ucx=/sw/summit/ums/ompix/gcc/6.4.0/install/ucx-1.7.0' '--with-cuda=/sw/summit/cuda/10.1.243' '--with-knem=/opt/knem-1.1.3.90mlnx1' 
    ```

 - UCX release 1.7.0
    ```
	 # UCT version=1.7.0 revision 9d06c3a
	 # configured with: --prefix=/sw/summit/ums/ompix/gcc/6.4.0/install/ucx-1.7.0 --disable-debug --disable-assertions --disable-params-check --enable-mt --with-gdrcopy=/sw/summit/gdrcopy/2.0 --with-cuda=/sw/summit/cuda/10.1.243 --with-knem=/opt/knem-1.1.3.90mlnx1
    ```

 - OMPI Collectives Tune `tjn-summit` branch
    - https://github.com/naughtont3/ompi-collectives-tuning.git

 - All using GCC toolchain (`gcc/6.4.0` module)
    ```
	 Currently Loaded Modules:
  	  1) hsi/5.0.2.p5    3) DefApps     5) cuda/10.1.243    7) ucx/1.7.0
      2) lsf-tools/2.0   4) gcc/6.4.0   6) openmpi/master

    ```

    ```
	 login1:$ module avail openmpi/master

	 -------------------- /sw/summit/ums/ompix/gcc/6.4.0/modules --------------------
   	     openmpi/master (L)

      ...<snip>...
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
	 login1:$ env | grep MCA
	 PRRTE_MCA_rmaps_base_no_schedule_local=1
	 PRRTE_MCA_routed=direct
	 OMPI_MCA_io=romio321

	 login1:$ env | grep UCX
	 UCX_DIR=/sw/summit/ums/ompix/gcc/6.4.0/install/ucx-1.7.0
	 UCX_INSTALL_DIR=/sw/summit/ums/ompix/gcc/6.4.0/install/ucx-1.7.0
	 UCX_MAX_RNDV_RAILS=2
	 UCX_NET_DEVICES=mlx5_0:1,mlx5_3:1
    ```

 - NOTE: "round2" There were several cases that failed on the inital runs,
   most look to be due to lack of walltime. So I am resubmitting that subset
   using a custom script to rerun just those cases.


Acks for Systems/Projects
-------------------------
 - This research used resources of the Oak Ridge Leadership Computing
   Facility at the Oak Ridge National Laboratory, which is supported by the
   Office of Science of the U.S. Department of Energy under Contract No.
   DE-AC05-00OR22725.

 - This research was supported by the Exascale Computing Project
   (17-SC-20-SC), a collaborative effort of the U.S. Department of Energy
   Office of Science and the National Nuclear Security Administration.

