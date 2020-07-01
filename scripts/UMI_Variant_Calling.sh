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

#fgbio GroupReadsByUmi \
#	--input=/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/Alignment/M_1-1_fused.bam --output=/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/grouped.bam \
#	--strategy=adjacency --edits=1 --min-map-q=20

#fgbio CallMolecularConsensusReads \
#	--input=/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/grouped.bam \
#	--output=/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/consensus.bam --min-reads=2 \
#	--rejects=/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/rejects.bam

#fgbio FilterConsensusReads \
#	--input=/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/consensus.bam \
#	--output=/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/consensus.filtered.bam \
#	--ref=/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/data/ref_KITL.fasta \
#	--min-reads=2 \
#	--min-base-quality=30

~/Demultiplexing/scripts/SamToFastq \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/consensus.filtered.bam \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/M_1-1_R1_UMI.fastq.gz \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/M_1-1_R2_UMI.fastq.gz

bwa mem -o /media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/consensus.filtered.mapped.sam \
	-R '@RG\tID:Run_K.1\tSM:M_1-1\tPL:illumina' -t 4 \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/data/ref_KITL.fasta \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/M_1-1_R1_UMI.fastq.gz \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/Fastqs/M_1-1_R2_UMI.fastq.gz

#Sorting mapped sam

samtools view -b -o /media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/consensus.filtered.mapped.bam \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/consensus.filtered.mapped.sam

java -jar $PICARD SortSam \
	INPUT=/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/consensus.filtered.mapped.bam \
	OUTPUT=/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/consensus.filtered.mapped.sort.bam \
	SO=queryname

java -jar $PICARD SortSam \
	INPUT=/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/consensus.filtered.bam \
	OUTPUT=/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/consensus.filtered.sort.bam \
	SO=queryname

 ~/Demultiplexing/scripts/MergeBamAlignment \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/consensus.filtered.mapped.sort.bam \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/consensus.filtered.sort.bam \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/UMI_Consensus/consensus.filtered.mapped.merged.bam \
	/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls/data/ref_KITL.fasta \
	FR -1
