#!/usr/bin/Rscript

scripts_dir <- '~/Demultiplexing/scripts/'
basecalls_dir <- '/media/bioinfo/TOSHIBA_EXT/200609_M03698_0018_000000000-D7K8R/Data/Intensities/BaseCalls'
setwd(basecalls_dir)

#--------------------------
#--------------------------

if(!dir.exists('./data/Demultiplexing_out')){dir.create('./data/Demultiplexing_out')}

#--------------------------
#--------------------------

system(paste(scripts_dir, 'ExtractIlluminaBarcodes-picard ',basecalls_dir,
             ' ./data/BARCODE_FILE.csv "251T8B9M8B251T" 1 ./data/Demultiplexing_out ./data/Demultiplexing_out/metrics_out.txt', 
             sep = ''))

#--------------------------
#--------------------------

system(paste(scripts_dir, 'IlluminaBasecallsToSam ', basecalls_dir,
             ' ./data/Demultiplexing_out 1 "251T8B9M8B251T" "Run_KitL_" ./data/library.params ', 
             basecalls_dir,'/tmp_dir', sep = ''))