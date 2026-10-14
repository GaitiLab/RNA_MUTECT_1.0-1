#!/bin/sh

#SBATCH --job-name=STARAlign
#SBATCH --partition=himem
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=59G
#SBATCH --output=slurm_out/%x_%j.out
#SBATCH --error=slurm_out/%x_%j.out

FASTQ_dir=$1 #abs path of directory where fastq files are stored
BAM_dir=$2 #abs path of directory where you want bam files to be stored
output_dir=$3 #abs path of directory where you want the extra files to be created

fa_file=$4 #abs path to fasta file
gtf_file=$5 #abs path to gtf file

echo "Building index files for STAR"
mkdir ${output_dir}/STAR_index_files
sbatch STAR_genomeGenerate.sh $fa_file $gtf_file ${output_dir}/STAR_index_files

bash makecsv.sh $FASTQ_dir $BAM_dir $output_dir

echo "Creating STAR scripts"
bash align_seq.sh $FASTQ_dir $BAM_dir ${output_dir}/STAR_index_files $gtf_file ${output_dir}/STAR_align.csv

echo "Running STAR scripts"
bash run_STAR_scripts.sh ${BAM_dir}/STAR_job_script.txt 
