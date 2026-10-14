#!/bin/bash
#
#SBATCH --job-name=SRA
#SBATCH --partition=veryhimem
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --output=slurm_out/%x_%j.out
#SBATCH --error=slurm_out/%x_%j.out

fasta_file=$1
gtf_file=$2
output_dir=$3

cd ${output_dir}
module load STAR
STAR --genomeDir STAR_genome_files --runMode genomeGenerate --genomeFastaFiles ${fasta_file} --sjdbGTFfile ${gtf_file} --sjdbOverhang 100

