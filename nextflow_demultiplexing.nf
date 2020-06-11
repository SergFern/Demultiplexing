#!/usr/bin/env nextflow

log.info """\

================================================================
D E M U L T I P L E X E R  - I R Y C I S    v 0.1
================================================================
input_directory        : $params.data
barcodes_output        : $params.outdir/params.barcodes_out
plarform               : $params.platform

================================================================
"""

Channel
      .fromPath(params.inputBCLdir, checkIfExists: true)

process ExtractIlluminaBarcodes {
  tag "Determine the sample barcode for every read in an Illumina sequencer lane"

  input:
    set val(value), file(file1) from ch_files
  output:
    set val(value), file(output) into ch_output

  script:
  """
  gatk ExtractIlluminaBarcodes BASECALLS_DIR=
  """
}