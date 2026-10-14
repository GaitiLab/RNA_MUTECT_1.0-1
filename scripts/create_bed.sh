#!/bin/bash
#SBATCH --partition=veryhimem
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --output=slurm_out/%x_%j.out
#SBATCH --error=slurm_out/%x_%j.out

file=$1
column=$2
output_dir=$3
output_name=$4

cut -f $column $file | awk 'NR>1' | awk -F'[:-]' 'BEGIN{OFS="\t";}{$1="chr"$1}1' > ${output_dir}/${output_name}_tmp.bed
awk  '$2!=""' ${output_dir}/${output_name}_tmp.bed > ${output_dir}/COSMIC_filter.bed
awk  '$3!=""' ${output_dir}/COSMIC_filter.bed > ${output_dir}/COSMIC_filter_2.bed
awk  '$2<=$3' ${output_dir}/COSMIC_filter_2.bed > ${output_dir}/${output_name}.bed

rm ${output_dir}/${output_name}_tmp.bed
rm ${output_dir}/COSMIC_filter.bed
rm ${output_dir}/COSMIC_filter_2.bed

sed 's/^chr//' ${output_dir}/${output_name}.bed > ${output_dir}/${output_name}_nochr.bed
