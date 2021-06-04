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
        bcl2fastq --runfolder-dir $data -d $params.demult_threads -p $params.demult_threads --output-dir $params.output 2> bcl2fastq.log
        """
}

//bclfastq --runfolder-dir $data -d $params.demult_threads -p $params.demult_threads --output-dir $params.outdir
