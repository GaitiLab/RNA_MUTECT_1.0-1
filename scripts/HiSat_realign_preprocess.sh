#!/bin/sh

#These are passed as inputs to this script:
LIB=$1 # <libdir>
BED=$2 #tumor maf file that contains point mutation information
BAM=$3 #BAM file
REFo=$4 #original reference seqeunce
NAME=$5 #sample id
xbase=${BAM##*/}
STUB=${xbase%.*}



echo "LIB: $LIB"
echo "BED: $BED"
echo "BAM: $BAM"
echo "REFo: $REFo"
echo "NAME: $NAME"
echo "STUB: $STUB"

#WORK_DIR=$(echo pwd) #working directory

#######################################################

echo "extracting paired reads from bam"

samtools view -L $BED $BAM | cut -f1 > IDs_all.txt
if [ "$?" -ne 0 ]; then echo "command extracting read IDs failed"; exit 1; fi

java -Xmx7g -jar $LIB/FilterSamReads.jar I=$BAM O=tmp_bam.bam READ_LIST_FILE=IDs_all.txt FILTER=includeReadList WRITE_READS_FILES=false VALIDATION_STRINGENCY=LENIENT
if [ "$?" -ne 0 ]; then echo "command generating BAM based on read list failed"; exit 1; fi


echo "convert bam to fastq"
samtools view -H tmp_bam.bam | sed '$d' - > tmp_header_T.sam
if [ "$?" -ne 0 ]; then echo "command failed"; exit 1; fi

samtools view tmp_bam.bam | awk '$2 < 2040 { print }' > tmp0_T.sam
if [ "$?" -ne 0 ]; then echo "command failed"; exit 1; fi

cat tmp_header_T.sam tmp0_T.sam > tmp_filteredbamT.sam

java -Xmx7g -jar $LIB/SamToFastq.jar I=tmp_filteredbamT.sam F=${NAME}_tmp_sequence_1.fastq F2=${NAME}_tmp_sequence_2.fastq VALIDATION_STRINGENCY=LENIENT
if [ "$?" -ne 0 ]; then echo "command failed"; exit 1; fi


##########################################################
#Writing Files to Annotations:
##########################################################

echo "writing out annotation file for upload"
echo -e "$PWD/${NAME}_tmp_sequence_1.fastq\n$PWD/${NAME}_tmp_sequence_2.fastq"   >> ${NAME}.rna_reads_fastq_list.list
echo "done"
