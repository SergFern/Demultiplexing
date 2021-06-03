#!/usr/bin/env nextflow

log.info """\

================================================================
D E M U L T I P L E X E R  - I R Y C I S    v 0.1
================================================================
run_directory          : $params.data
barcodes_output        : $params.outdir/params.barcodes_out
demultiplexing_threads  : $params.demult_threads

================================================================
"""

nextflow.enable.dsl=2
data = channel.fromPath('$params.data')

