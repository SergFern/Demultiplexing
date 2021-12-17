#!/usr/bin/env nextflow

nextflow.enable.dsl=2

def helpMessage() {
    log.info"""

	================================================================
	D E M U L T I P L E X E R  - I R Y C I S    v 0.9
	================================================================

    Usage:
    The typical command for running the pipeline is as follows:
    ./nextflow_GenomeMapper.nf [OPTIONS]

    Options:

    --inputBCLdir [DIR]             Base directory with sequenced data.
    --output [DIR]                  Default path to output fastq files.
    --demultiplexing_threads [INT]  Threads assigned to demultiplexing process.
    --UMI [BOOL]                    Execute demultiplexing with UMIs command.

    if UMI is true

    --IndexSize [INT]               Size of indexes: default: 8
    --UMISize [INT]                 Size of UMIs: default: 10

    BEWARE
    
    Index and UMI size may not be the only thing to adapt, you might need to also add other indexes at 3', or the arrangement could be altered.
    
""".stripIndent()
}

/*
TODO: Consider setting the whole indexSize,UmiSize arrangement in a variable: ex. params.barcode = Y*,I8,Y10,Y*
*/

// Show help message if --help specified
if (params.help){
helpMessage()
exit 0
}

log.info """\

================================================================
D E M U L T I P L E X E R  - I R Y C I S    v 0.9
================================================================
inputBCLdir             : $params.inputBCLdir
output                  : $params.output
demultiplexing_threads  : $params.demult_threads
UMI                     : $params.UMI
================================================================
"""

include { BCL2FASTQ as bcl2fastq } from './modules/bcl2fastq'

workflow {
  data = channel.fromPath(params.inputBCLdir, type: 'dir', checkIfExists: true)
  bcl2fastq(data)
}