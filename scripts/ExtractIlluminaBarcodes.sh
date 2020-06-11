#!/bin/bash


#Parameters:

ExtractIlluminaBarcodes=$0
inputBCL_dir=$1
barcodeFile=$2
read_structure=$3
lane=$4
barcodes_output_dir=$5
barcodes_metrics=$6

java -Xmx4g -jar $PICARD $ExtractIlluminaBarcodes \
		BASECALLS_DIR=$inputBCL_dir \
		BARCODE_FILE=$barcodeFile \
		READ_STRUCTURE=$read_structure \
		LANE=$lane \
		OUTPUT_DIR=$barcodes_output_dir \
		METRICS_FILE=$barcodes_metrics.txt

