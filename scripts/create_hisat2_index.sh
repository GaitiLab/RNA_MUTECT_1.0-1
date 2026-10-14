_#!/bin/bash
#SBATCH --partition=veryhimem
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --output=slurm_out/%x_%j.out
#SBATCH --error=slurm_out/%x_%j.out

fa_file=$1
output_dir=$2
output_basename=$3

cd output_dir
module load hisat2
hisat2-build $fa_file $output_basename
