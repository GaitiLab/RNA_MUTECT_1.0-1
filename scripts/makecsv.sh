#!/bin/bash

FASTQ_dir=$1
BAM_dir=$2
output_dir=$3

cd ${FASTQ_dir}

if [ ! -d ${BAM_dir}/STAR_results ]
then
    for i in SRR*/
    do
        ls -1 $i >> ${output_dir}/STAR_align.csv
    done
else
    for i in SRR*/
    do
        if [ ! -d /cluster/projects/gaitigroup/SLE_BAMfile/STAR_results/$i ]
        then
            ls -1 $i >> ${output_dir}/STAR_align.csv
        fi
    done
fi
