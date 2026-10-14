#!/bin/sh


data_directory=$1 #directory of where fastq files are stored
output_directory=$2 #directory of where you want the output to be stored
genome_path=$3 #absolute path to processed genome index to be used for STAR alignment
annotation_path=$4 #abs path to genome annotation file (typically .gtf file)
filesOfInterest=$5 #abs path to .csv file containing .fastq file names


#Reading csv file (files_of_interest) into array
files_of_interest=()
while read -r line || [ -n "$line" ]; do files_of_interest+=("${line}"); done < "${filesOfInterest}"

echo "Processing files"

cd $output_directory
mkdir -p STAR_scripts
mkdir -p STAR_results
results="${output_directory}/STAR_results"
scripts="${output_directory}/STAR_scripts"
mkdir -p $results/coord_bams
mkdir -p $results/star_logs
mkdir -p $results/star_logs/Init_QCMetrics
mkdir -p $results/star_logs/Init_Runmsgs

i=0
filelen=${#files_of_interest[@]}

while [ $i -lt $filelen ]; do
    r1=${files_of_interest[$i]}
    ((i=$i+1))
    r2=${files_of_interest[$i]}
    ((i=$i+1))
    
    samplename=$(echo "$r1" | cut -f 1 -d '_')
    
    #Writing the script to process each sample
    echo '#!/bin/bash' >> "$scripts/STAR_script_${samplename}.sh"
    echo '#SBATCH --job-name=SEQAlign' >> "$scripts/STAR_script_${samplename}.sh"
    echo '#SBATCH --partition=veryhimem' >> "$scripts/STAR_script_${samplename}.sh"
    echo '#SBATCH --time=12:00:00' >> "$scripts/STAR_script_${samplename}.sh"
    echo '#SBATCH --ntasks=1' >> "$scripts/STAR_script_${samplename}.sh"
    echo '#SBATCH --nodes=1' >> "$scripts/STAR_script_${samplename}.sh"
    echo '#SBATCH --cpus-per-task=8' >> "$scripts/STAR_script_${samplename}.sh"
    echo '#SBATCH --mem=64G' >> "$scripts/STAR_script_${samplename}.sh"
    echo '#SBATCH --output=slurm_out/%x_%j.out' >> "$scripts/STAR_script_${samplename}.sh"
    echo '#SBATCH --error=slurm_out/%x_%j.out' >> "$scripts/STAR_script_${samplename}.sh"

    echo module load STAR >> "$scripts/STAR_script_${samplename}.sh"
    echo mkdir $results/${samplename} >> "$scripts/STAR_script_${samplename}.sh"
    echo STAR --genomeDir $genome_path --runThreadN 12 --sjdbGTFfile $annotation_path --readFilesIn "${data_directory}/${samplename}/$r1" "${data_directory}/${samplename}/$r2" --outFileNamePrefix "$results/${samplename}_" --quantMode GeneCounts --outSAMtype BAM SortedByCoordinate >> "$scripts/STAR_script_${samplename}.sh"
    echo mv "$results/${samplename}_Aligned.sortedByCoord.out.bam" "${results}/coord_bams/" >> "${output_directory}/STAR_scripts/STAR_script_${samplename}.sh"
    echo mv "$results/${samplename}_Log.final.out" "${results}/star_logs/Init_QCMetrics/" >> "$scripts/STAR_script_${samplename}.sh"
    echo mv "$results/${samplename}_Log.out" "${results}/star_logs/Init_Runmsgs/" >> "${output_directory}/STAR_scripts/STAR_script_${samplename}.sh"
    echo mv "$results/${samplename}_Log.progress.out" "${results}/${samplename}" >> "${output_directory}/STAR_scripts/STAR_script_${samplename}.sh"
    echo mv "$results/${samplename}__STARgenome" "$results/${samplename}/"  >> "$scripts/STAR_script_${samplename}.sh"
    echo mv "$results/${samplename}__STARtmp" "$results/${samplename}/"  >> "$scripts/STAR_script_${samplename}.sh"
    echo mv "$results/${samplename}_ReadsPerGene.out.tab" "$results/${samplename}/"  >> "$scripts/STAR_script_${samplename}.sh"
    echo mv "$results/${samplename}_SJ.out.tab" "$results/${samplename}/"  >> "$scripts/STAR_script_${samplename}.sh"
    chmod +x $scripts/STAR_script_${samplename}.sh
    echo "A script has been generated for sample $samplename . Script has the name STAR_script_${samplename}.sh."

done

#Run each of the created STAR scripts.
cd ${output_directory}/STAR_scripts/

for file in $(ls *.sh); do
  echo "${output_directory}/STAR_scripts/$file" >> STAR_job_script.txt
done

mv STAR_job_script.txt ${output_directory}
