#!/bin/bash
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

numcoll=0
config_file=""
with_slurm=false
with_lsf=false

usage()
{
	echo "Usage:
		$0
		   -c | --config-file <config>
		   --with-slurm
Options:
		   --config-file (string)
			The file containing global configurations.
		   --with-slurm
		   --with-lsf
			Use slurm or lsf instead of the default SGE." 1>&2; exit 1;

}

OPTIONS=$(getopt -o :c: --long with-slurm,with-lsf,config-file: -- "$@")

if [[ $? -ne 0 ]]; then
        usage
        exit 1
fi

eval set -- "$OPTIONS"
while true; do
        case "$1" in
                '-c'|'--config-file')
                        case "$2" in
				"") shift 2 ;;
				*) config_file=$2; shift 2 ;;
			esac
			;;
		'--with-slurm')
			with_slurm=true
			shift
			;;
		'--with-lsf')
			with_lsf=true
			shift
			;;
                '--')
                        shift
                        break
			;;
                *) echo "Internal error!"; usage; exit 1 ;;
	esac
done

if [ "$config_file" = "" ]; then
	usage
	exit 1
fi

# TJN: Avoid picking up lines elsewhere in config file that
#      might contain 'collectives', e.g., in paths.
collectives=$(cat $config_file | grep "collectives.*:")
collectives=$(cut -d ":" -f 2 <<< "$collectives")
work_dir=$(dirname "$0")

if [ $with_slurm = true ]; then
	echo "CMD: python coltune_script.py $config_file slurm"
	python coltune_script.py $config_file slurm

	if [ $? -ne 0 ]; then
		echo "Failed to create job scripts. Exiting.."
		exit 1;
	fi

	for collective in ${collectives// / } ; do
		echo "CMD: sbatch -W $work_dir/output/$collective/${collective}_coltune.sh"
		sbatch -W $work_dir/output/$collective/${collective}_coltune.sh
	done
	echo "CMD: python coltune_analyze.py $config_file"
	python coltune_analyze.py $config_file
elif [ $with_lsf = true ]; then
	echo "CMD: python coltune_script.py $config_file lsf"
	python coltune_script.py $config_file lsf

	if [ $? -ne 0 ]; then
		echo "Failed to create job scripts. Exiting.."
		exit 1;
	fi

	for collective in ${collectives// / } ; do
        job_name="$collective"
        proj_acct="STF010"
		echo "CMD: bsub -P $proj_acct $work_dir/output/$collective/${collective}_coltune.sh"
		bsub -P $proj_acct $work_dir/output/$collective/${collective}_coltune.sh
        echo "CMD: bwait -w \"ended($job_name)\""
        bwait -w "ended($job_name)"
	done
	echo "CMD: python coltune_analyze.py $config_file"
	python coltune_analyze.py $config_file
else
	python coltune_script.py $config_file sge
	if [ $? -ne 0 ]; then
		echo "Failed to create job scripts. Exiting.."
		exit 1;
	fi

	for collective in ${collectives// / } ; do
		qsub -N $collective -cwd $work_dir/output/$collective/${collective}_coltune.sh
	done
	collective_string=$(echo $collectives | sed 's/ /,/g')
	qsub -hold_jid $collective_string $work_dir/analyze.sh -c $config_file
fi

exit

