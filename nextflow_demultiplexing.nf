#!/usr/bin/env nextflow

nextflow.enable.dsl=2

log.info """\

================================================================
D E M U L T I P L E X E R  - BCL2FASTQ    v 0.2
================================================================
inputBCLdir             : $params.inputBCLdir
output                  : $params.output
demultiplexing_threads  : $params.demult_threads
================================================================
"""

include { BCL2FASTQ as bcl2fastq } from './modules/bcl2fastq'

workflow {
  data = channel.fromPath(params.inputBCLdir, type: 'dir', checkIfExists: true)
  bcl2fastq(data)
}