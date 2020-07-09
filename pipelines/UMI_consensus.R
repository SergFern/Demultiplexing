#!/usr/bin/Rscript

# system(paste(,sep = ''))

scripts_dir <- '~/Demultiplexing/scripts/'
basecalls_dir <- '/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls'
unmapped_dir <- paste(basecalls_dir, '/unaligned_bams', sep = '')
file.ref <- paste('ref_KITL.fasta' ,sep = '')

for(file in dir(unmapped_dir)){
  
  name <- strsplit(file, split = '_unmapped')[[1]][1]
  
  cat('\n#######################################################################\n')
  cat('#######################################################################\n\n')
  
  cat(paste('Processing file: ', file,'\n', sep = ''))
  
  cat('\n#######################################################################\n')
  cat('#######################################################################\n\n')

  #--------------------------
    file.in <- paste(name, '.bwa.mapped.bam', sep = '')
    file.out <- paste(name, '.bwa.grouped.bam', sep = '')
  #--------------------------
  
system(paste("fgbio GroupReadsByUmi ",
             "--input=", basecalls_dir, "/Fastqs/Alignment/", file.in, ' ',
             "--output=", basecalls_dir,"/UMI_Consensus/", file.out, ' ',
             "--strategy=adjacency --edits=1 --min-map-q=20", sep = ''))
    
  #--------------------------
    file.in <- paste(name, '.bwa.grouped.bam', sep = '')
    file.out <- paste(name, '.bwa.grouped.consensus.bam', sep = '')
    file.out_rejects <- paste(name, '.bwa.grouped.rejects.bam', sep = '')
  #--------------------------

system(paste("fgbio CallMolecularConsensusReads ",
             "--input=",basecalls_dir,"/UMI_Consensus/",file.in, ' ', 
             "--output=",basecalls_dir,"/UMI_Consensus/",file.out, ' ', 
             "--rejects=",basecalls_dir,"/UMI_Consensus/",file.out_rejects, ' ', 
             "--read-group-id=Run_K.1 ",
             "--error-rate-post-umi=30 ",
             "--min-reads=1"
             ,sep = ''))
      
  #--------------------------
    file.in <- paste(name, '.bwa.grouped.consensus.bam', sep = '')
    file.out <- paste(name, '.bwa.grouped.consensus.filtered.bam', sep = '')
  #--------------------------

system(paste("fgbio FilterConsensusReads ",
             "--input=",basecalls_dir,"/UMI_Consensus/", file.in, ' ',
             "--output=",basecalls_dir,"/UMI_Consensus/", file.out, ' ',
             "--ref=",basecalls_dir, "/data/", file.ref, ' ',
             "--min-reads=3 ",
             "--min-base-quality=40 ",
             "--reverse-per-base-tags=true ",
             "-E 0.05 ",
             "-e 0.1 ",
             "-n 0.1",sep = ''))
        
  #--------------------------
    file.in <- paste(name, '.bwa.grouped.consensus.bam', sep = '')
    file.out_1 <- paste(name, '_L001_R1_001.umi.fastq.gz', sep = '')
    file.out_2 <- paste(name, '_L001_R2_001.umi.fastq.gz', sep = '')
  #--------------------------

system(paste(scripts_dir,'SamToFastq_interleave ',
             basecalls_dir, '/UMI_Consensus/', file.in,' ',
             basecalls_dir, '/Fastqs/', file.out_1, ' ',
             basecalls_dir, '/Fastqs/', file.out_2,sep = ''))

}