#!/usr/bin/env nextflow

nextflow.enable.dsl=2

def helpMessage() {
    log.info"""

	================================================================
	D E M U L T I P L E X E R  - I R Y C I S    v 1
	================================================================

    Usage:
    The typical command for running the pipeline is as follows:
    ./nextflow_demultiplexing.nf [OPTIONS]

    Options:

    --inputBCLdir [DIR]             Base directory with sequenced data.
    --output [DIR]                  Default path to output fastq files.
    --demultiplexing_threads [INT]  Threads assigned to demultiplexing process.
    --UMI [STR]                     Execute demultiplexing with UMIs command, if "custom" will use --barcode to override standard --IndexSize and --UMISize. default: false
    --barcode [STR]                 Custom index and umi arrangement ex: Y*,I9,Y8,I9,Y*

    if UMI is true

    --IndexSize [INT]               Size of indexes: default: 8
    --UMISize [INT]                 Size of UMIs: default: 10

    BEWARE
    
    Index and UMI size may not be the only thing to adapt, you might need to also add other indexes at 3', or the arrangement could be altered.
    
""".stripIndent()
}

/*
TODO: Consider setting the whole indexSize,UmiSize arrangement in a variable: ex. params.barcode = "Y*,I8,Y10,Y*"
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
demultiplexing_threads  : $params.demultiplexing_threads
UMI                     : $params.UMI
email notification      : $params.email
================================================================
"""

include { BCL2FASTQ as bcl2fastq } from './modules/bcl2fastq'

workflow {
  data = channel.fromPath(params.inputBCLdir, type: 'dir', checkIfExists: true)
  bcl2fastq(data)
}

workflow.onComplete {
  
    def carrera = """${params.inputBCLdir}"""
    def email = """${params.email}"""
    def subject = """Demultiplexado ${carrera}"""

    def msg = """\
        Resumen de ejecucion de demultiplexado
        ---------------------------
        Run         : ${carrera}
        Completed at: ${workflow.complete}
        Duration    : ${workflow.duration}
        Success     : ${workflow.success}
        """
        .stripIndent()

    sendMail(to: email, subject: subject, body: msg)
}