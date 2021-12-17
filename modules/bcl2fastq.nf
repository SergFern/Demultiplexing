#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process BCL2FASTQ {
    publishDir = "results"

    input:
        path data
    output:
        file('*')
    script:
        if($params.UMI == false){
        """
        bcl2fastq --runfolder-dir $data -d $params.demult_threads -p $params.demult_threads --output-dir $params.output 2> bcl2fastq.log
        """
        }else if($params.UMI == true){
        """
        bcl2fastq --runfolder-dir $data -d $params.demult_threads -p $params.demult_threads --output-dir $params.output --with-failed-reads --mask-short-adapter-reads 0 --use-bases-mask Y*,I$params.IndexSize,Y$params.UMISize,Y* 2> bcl2fastq.log
        """
        }
}

/* COMMENT SECTION
bcl2fastq -h 2> bclfastq.help
echo $data >> bclfastq.help
echo $params.demult_threads >> bclfastq.help
echo $params.output >> bclfastq.help
// TODO: is the trial the same as the backup? - no, why?
*/