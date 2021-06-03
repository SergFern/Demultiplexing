#!/bin/bash

version="program version #0.1
Written by bioinfo-serg."

usage="Usage: $0 [OPTION]... [FILE]...
Description

Mandatory arguments to long options are mandatory for short options too.

  -short_option, --long_option	description
      --help        display this help and exit
      --version     display version information and exit

With no FILE read standard input.

Report bugs to <your therapist>."

case $1 in
--help)    exec echo "$usage";;
--version) exec echo "$version";;
esac

 ~/Demultiplexing/scripts/ExtractIlluminaBarcodes-picard /media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls ./data/BARCODE_FILE.csv "251T8B9M8B251T" 1 ./data/Demultiplexing_out ./data/Demultiplexing_out/metrics_out.txt

~/Demultiplexing/scripts/IlluminaBasecallsToSam /media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls /media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/data/Demultiplexing_out 1 "251T8B9M8B251T" "Run_KitL_" ./data/library.params /media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/tmp_dir

~/Demultiplexing/scripts/SamToFastq /media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/unaligned_bams/M_1-1_unmapped.bam /media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/M_1-1_L001_R1_001.fastq.gz /media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/M_1-1_L001_R2_001.fastq.gz

bwa mem -o /media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/Alignment/M_1-1.bwa.sam \
	-R '@RG\tID:Run_K.1\tSM:M_1-1\tPL:illumina' -t 1 \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/data/ref_KITL.fasta \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/M_1-1_L001_R1_001.fastq.gz \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/M_1-1_L001_R2_001.fastq.gz

samtools view -b -o /media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/Alignment/M_1-1.bwa.bam /media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/Alignment/M_1-1.bwa.sam

java -jar $PICARD SortSam \
	INPUT=/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/Alignment/M_1-1.bwa.bam \
	OUTPUT=/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/Alignment/M_1-1.bwa.sort.bam \
	SO=queryname

~/Demultiplexing/scripts/MergeBamAlignment \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/Alignment/M_1-1.bwa.sort.bam \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/unaligned_bams/M_1-1_unmapped.bam \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/Alignment/M_1-1_fused.bam \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/data/ref_KITL.fasta \
	TANDEM -1
