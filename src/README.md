# Required files 


* `funcotator_dataSources.v1.7.20200521s`, can be downloaded as follows:  
  * Google Bucket: <https://console.cloud.google.com/storage/browser/broad-public-datasets/funcotator/funcotator_dataSources.v1.7.20200521s;tab=objects?prefix=&forceOnObjectsSortingFiltering=false>
  * https://docs.cloud.google.com/storage/docs/downloading-objects#console-download-object
* `humandb` with the following files can be downloaded through https://annovar.openbioinformatics.org/en/latest/user-guide/download/ (see also: `humandb/annovar_downdb.log`)
  * [hg19_refGene.txt](humandb/hg19_refGene.txt) 
  * [hg19_refGeneMrna.fa](humandb/hg19_refGeneMrna.fa) 
  * [hg19_refGeneVershg19_refGene.txt](humandb/hg19_refGeneVershg19_refGene.txt)
* `indices` -> these can be generated for any reference genome
  * BWA_Homo_sapiens_assembly19
  * HISAT_Homo_sapiens_assembly19
  * STAR_Homo_sapiens_assembly19
* `reference_genome` can be downloaded from: https://console.cloud.google.com/storage/browser/gcp-public-data--broad-references/hg19/v0
  * Homo_sapiens_assembly19.dict, 
  * Homo_sapiens_assembly19.fasta, 
  * Homo_sapiens_assembly19.fasta.fai
* `References/` can be downloaded from: [gcp-public-data--broad-references/hg19/v0](https://console.cloud.google.com/storage/browser/_details/gcp-public-data--broad-references/hg19/v0)  
  * References/1000G_phase1.indels.b37.vcf -> https://storage.googleapis.com/gatk-legacy-bundles/b37/1000G_phase1.indels.b37.vcf
  * References/1000G_phase1.indels.b37.vcf.idx -> https://storage.googleapis.com/gatk-legacy-bundles/b37/1000G_phase1.indels.b37.vcf.idx
  * References/b37_cosmic_v54_120711.vcf -> https://storage.googleapis.com/gatk-legacy-bundles/b37/cosmic_v54_120711.b37.vcf
  * References/b37_cosmic_v54_120711.vcf.idx -> https://storage.googleapis.com/gatk-legacy-bundles/b37/cosmic_v54_120711.b37.vcf.idx
  * References/hg19-v0-Homo_sapiens_assembly19.dbsnp138.vcf ->  https://storage.googleapis.com/gcp-public-data--broad-references/hg19/v0/Homo_sapiens_assembly19.dbsnp138.vcf
  * References/hg19-v0-Homo_sapiens_assembly19.dbsnp138.vcf.idx -> https://storage.googleapis.com/gcp-public-data--broad-references/hg19/v0/Homo_sapiens_assembly19.dbsnp138.vcf.idx
  * References/Homo_sapiens_assembly19.gtf -> can be easily generated using https://primerseq.sourceforge.net/gtf.html
  * References/Mills_and_1000G_gold_standard.indels.b37.vcf -> https://storage.googleapis.com/gatk-legacy-bundles/b37/Mills_and_1000G_gold_standard.indels.b37.vcf
  * References/Mills_and_1000G_gold_standard.indels.b37.vcf.idx -> https://storage.googleapis.com/gatk-legacy-bundles/b37/Mills_and_1000G_gold_standard.indels.b37.vcf.idx
* `References_v2/`
  * References_v2/1000G_omni2.5.b37.vcf.gz -> https://storage.googleapis.com/gcp-public-data--broad-references/hg19/v0/1000G_omni2.5.b37.vcf.gz
  * References_v2/1000G_omni2.5.b37.vcf.gz.tbi -> https://storage.googleapis.com/gcp-public-data--broad-references/hg19/v0/1000G_omni2.5.b37.vcf.gz.tbi
  * References_v2/1000G_phase1.snps.high_confidence.b37.vcf.gz -> https://storage.googleapis.com/gcp-public-data--broad-references/hg19/v0/1000G_phase1.snps.high_confidence.b37.vcf.gz
  * References_v2/1000G_phase1.snps.high_confidence.b37.vcf.gz.tbi -> https://storage.googleapis.com/gcp-public-data--broad-references/hg19/v0/1000G_phase1.snps.high_confidence.b37.vcf.gz.tbi
  * References_v2/Homo_sapiens_assembly19.dbsnp138.vcf -> https://storage.googleapis.com/gcp-public-data--broad-references/hg19/v0/Homo_sapiens_assembly19.dbsnp138.vcf
  * References_v2/Homo_sapiens_assembly19.dbsnp138.vcf.idx -> https://storage.googleapis.com/gcp-public-data--broad-references/hg19/v0/Homo_sapiens_assembly19.dbsnp138.vcf.idx