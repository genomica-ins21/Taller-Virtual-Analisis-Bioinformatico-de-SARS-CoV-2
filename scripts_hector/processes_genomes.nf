#!/usr/bin/env nextflow

process runGuppy {
    publishDir "${params.output_dir}/results_basecalling",
    mode: 'copy'

    input:
    path(fast5, type:dir)
    output:
    path(results_basecalling, type:dir)

    script:
    if( params.model == 'hac')
        """
        guppy_basecaller -i $fast5 \
        -s "${baseDir}/results_basecalling" \
        -c dna_r9.4.1_450bps_hac.cfg \
        -m template_r9.4.1_450bps_hac.jsn \
        --barcode_kits "EXP-NBD196" \
        --require_barcodes_both_ends --compress_fastq --trim_barcodes \
        -x "cuda:0,1" --gpu_runners_per_device 20 --num_callers 4 --chunks_per_runner 1024 --chunk_size 1000
        """
    else if( params.model == 'fast')
        """
        guppy_basecaller -i $fast5 \
        -s "${baseDir}/results_basecalling" \
        -c dna_r9.4.1_450bps_fast.cfg \
        -m template_r9.4.1_450bps_fast.jsn \
        --barcode_kits "EXP-NBD196" \
        --require_barcodes_both_ends --compress_fastq --trim_barcodes \
        -x "cuda:0,1" --gpu_runners_per_device 20 --num_callers 4 --chunks_per_runner 1024 --chunk_size 1000
        """
    else
        throw new IllegalArgumentException("Modelo no reconocido: ${params.model}. Las opciones son: [hac; fast] ")
}


process RUN_ARTIC {

    input:
    file x from letters.flatten()

    output:
    stdout result

    """
    cat $x | tr '[a-z]' '[A-Z]'
    """
}

process RUN_PANGOLIN {

    input:

    output:

    """

    """
}

process RUN_NEXTCLADE{

    input:

    output:

    """

    """
}

process ALIGN{

    input:

    output:

    """

    """
}

process MAKE_REPORT{

    input:

    output:

    """

    """
}
result.view { it.trim() }