#!/usr/bin/Rscript

scripts_dir <- '~/Demultiplexing/scripts/'
basecalls_dir <- '/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls'
unmapped_dir <- paste(basecalls_dir, '/unaligned_bams', sep = '')
file.ref <- paste('ref_KITL.fasta' ,sep = '')

setwd(basecalls_dir)

for(file in dir(unmapped_dir)){
  
  cat('\n#######################################################################\n')
  cat('#######################################################################\n\n')
  
  cat(paste('Processing file: ', file,'\n', sep = ''))
  
  cat('\n#######################################################################\n')
  cat('#######################################################################\n\n')
  
  name <- strsplit(file, split = '_unmapped')[[1]][1]
  
  #--------------------------
  file.out_1 <- paste(name, '_L001_R1_001.fastq.gz', sep = '')
  file.out_2 <- paste(name, '_L001_R2_001.fastq.gz', sep = '')
  #--------------------------

  system(paste(scripts_dir,'SamToFastq ', unmapped_dir,'/',file,' ',basecalls_dir,'/Fastqs/',file.out_1,' ',
               basecalls_dir,'/Fastqs/',file.out_2, sep = ''))
  
  #--------------------------
  file.in_1 <- file.out_1
  file.in_2 <- file.out_2
  file.out_sam <- paste(name, '.bwa.sam', sep = '')
  #--------------------------
  
  system(paste("bwa mem -o ", basecalls_dir,"/Fastqs/Alignment/", file.out_sam,
         " -R '@RG\\tID:Run_K.1\\tSM:M_1-1\\tPL:illumina' -t 1 ",
         basecalls_dir,"/data/", file.ref, ' ',
         basecalls_dir, "/Fastqs/", file.in_1,' ',
         basecalls_dir, "/Fastqs/", file.in_2, sep = ''))
  
  #-------------------------
  file.in <- file.out_sam
  file.out_bam <- paste(name, '.bwa.bam', sep = '')
  #-------------------------
  
  system(paste("samtools view -b -o ",basecalls_dir,"/Fastqs/Alignment/", file.out_bam,' ',basecalls_dir,"/Fastqs/Alignment/", file.in, sep = ''))
  
  #-------------------------
  file.in <- file.out_bam
  file.out <- paste(name, '.bwa.sort.bam', sep = '')
  #--------------------------
  system(paste("java -jar $PICARD SortSam ",
               "INPUT=",basecalls_dir,"/Fastqs/Alignment/",file.in,' ',
               "OUTPUT=", basecalls_dir, "/Fastqs/Alignment/", file.out,' ',
               "SO=queryname",sep = ''))
  
  #-------------------------
  file.in_mapped <- file.out
  file.in_unmapped <- file
  file.out <- paste(name, '.bwa.mapped.bam', sep = '')
  #--------------------------
  
  system(paste(scripts_dir, "MergeBamAlignment ", 
               basecalls_dir, "/Fastqs/Alignment/", file.in_mapped, ' ',
               basecalls_dir, "/unaligned_bams/", file.in_unmapped, ' ',
               basecalls_dir, "/Fastqs/Alignment/", file.out, ' ',
               basecalls_dir, "/data/", file.ref, ' ',
               "TANDEM -1", sep = ''))

}