#!/bin/sh

#SBATCH --job-name=RNAMutect
#SBATCH --partition=veryhimem
#SBATCH --time=12:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --output=slurm_out/%x_%j.out
#SBATCH --error=slurm_out/%x_%j.out

jar_directory=$1 #abs path to directory containing .jar files
bed_file=$2 #absolute path to input BED file
rna_BAM=$3 #absolute path to RNA sample BAM file
matched_normal_DNA_BAM=$4 #absolute path to matched normal DNA BAM file
genome_ref=$5 #abs path to genome reference genome in fasta format
case_sample_ID=$6 #ID of case sample
control_sample_ID=$7 #ID of control sample
rna_mutect_repo=$8 #abs path to RNA Mutect repo directory
hisat2_index_dir=$9 #abs path to hisat2 index files     
hisat2_basename=${10} #basename for hisat2 index files
output_dir=${11} #abs path to output directory

#Realignment Step

#Extracts all the reads from the corresponding BAM file that are aligned with the called mutations and will write them into fastq files. 
#A text file with the path to the new fastq files will be generated.

cd ${output_dir}
samtools view -f 0x2 -b $rna_BAM > ${output_dir}/Filtered_${case_sample_ID}.bam
samtools view -f 0x2 -b $matched_normal_DNA_BAM > ${output_dir}/Filtered_${control_sample_ID}.bam

sh ${rna_mutect_repo}/HiSat_realign_preprocess.sh $jar_directory $bed_file ${output_dir}/Filtered_${case_sample_ID}.bam $genome_ref $case_sample_ID
sh ${rna_mutect_repo}/HiSat_realign_preprocess.sh $jar_directory $bed_file ${output_dir}/Filtered_${control_sample_ID}.bam $genome_ref $control_sample_ID


#Run HiSat2 aligner on output from realignment step
module load hisat2
case_sample_output=()
while read -r line || [ -n "$line" ]; do case_sample_output+=("${line}"); done < "${case_sample_ID}.rna_reads_fastq_list.list"

control_sample_output=()
while read -r line || [ -n "$line" ]; do control_sample_output+=("${line}"); done < "${control_sample_ID}.rna_reads_fastq_list.list"

cd $hisat2_index_dir

hisat2 -x ${hisat2_basename} -1 ${case_sample_output[0]} -2 ${case_sample_output[1]} -X 800 >> "${output_dir}/${case_sample_ID}_hisat2.bam" 
hisat2 -x ${hisat2_basename} -1 ${control_sample_output[0]} -2 ${control_sample_output[1]} -X 800 >> "${output_dir}/${control_sample_ID}_hisat2.bam"

Run MuTect with created HiSat2 bams
module load mutect

java -jar ${jar_directory}/picard.jar AddOrReplaceReadGroups I=${output_dir}/${control_sample_ID}_hisat2.bam O=${output_dir}/${control_sample_ID}_hisat2_rg.bam RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20
java -jar ${jar_directory}/picard.jar AddOrReplaceReadGroups I=${output_dir}/${case_sample_ID}_hisat2.bam O=${output_dir}/${case_sample_ID}_hisat2_rg.bam RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20

java -jar ${jar_directory}/picard.jar ReorderSam \
     I=${output_dir}/${control_sample_ID}_hisat2_rg.bam \
     O=${output_dir}/${control_sample_ID}_final.bam \
     R=${genome_ref} \
     CREATE_INDEX=TRUE

java -jar ${jar_directory}/picard.jar ReorderSam \
     I=${output_dir}/${case_sample_ID}_hisat2_rg.bam \
     O=${output_dir}/${case_sample_ID}_final.bam \
     R=${genome_ref} \
     CREATE_INDEX=TRUE

module load samtools
samtools sort ${output_dir}/${control_sample_ID}_final.bam > ${output_dir}/${control_sample_ID}_final_sorted.bam
samtools sort ${output_dir}/${case_sample_ID}_final.bam > ${output_dir}/${case_sample_ID}_final_sorted.bam
samtools index ${output_dir}/${control_sample_ID}_final_sorted.bam ${output_dir}/${control_sample_ID}_final.bam.bai
samtools index ${output_dir}/${case_sample_ID}_final_sorted.bam ${output_dir}/${case_sample_ID}_final.bam.bai

java -jar $mutect_dir/muTect.jar \
-T MuTect \
-R $genome_ref \
--intervals $bed_file \
--input_file:normal "${output_dir}/${control_sample_ID}_final_sorted.bam" \
--input_file:tumor "${output_dir}/${case_sample_ID}_final_sorted.bam" \
-U ALLOW_N_CIGAR_READS \
--force_output \
--out ${output_dir}/${control_sample_ID}_vs_${case_sample_ID}.call_stats.txt

rm ${output_dir}/${control_sample_ID}_hisat2_rg.bam
rm ${output_dir}/${case_sample_ID}_hisat2_rg.bam
rm ${output_dir}/${control_sample_ID}_final.bam 
rm ${output_dir}/${case_sample_ID}_final.bam 


