#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process BCL2FASTQ {
    publishDir = "results"

    input:
        path data
    output:
        file('*')
    script:
        """
        bcl2fastq -h 2> bclfastq.help
        """
}

//bclfastq --runfolder-dir $data -d $params.demult_threads -p $params.demult_threads --output-dir $params.outdir
