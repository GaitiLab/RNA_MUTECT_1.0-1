#!bin/bash

sra_dir=$1
output_dir=$2

module load sratoolkit/3.0.0

cd $sra_dir

for i in *sra
do 
    filename=$(basename "$i" .sra)
    if [ ! -d ${output_dir}/$filename ]
    then
        echo "prepping $filename"
        mkdir ${output_dir}/$filename
        cd ${output_dir}/$filename
    
        echo "converting $filename"
        fasterq-dump ${sra_dir}/$i
    
        echo "$filename done"
    fi
done
