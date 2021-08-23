nextflow.enable.dsl=2

params.fast5_dir = false
params.output_dir = false
params.model = "hac"
params.aligner = "bwa"



include { RUN_GUPPY; RUN_ARTIC; RUN_PANGOLIN; RUN_NEXTCLADE; RUN_METRICS; MAKE_REPORT; ALIGN} from './processes/processes_genomes'

workflow {
  if (params.fast5_dir && params.output_dir) {
    fast5 = Channel
      .fromPath(params.fast5_dir)
      .ifEmpty { error "No se encuentra el directorio fast5: ${params.fasta_file}" }
    
    println """\
    			Secuenciacion MinION de SARS-CoV-2
    			----------------------------------
    			----------------------------------
    			archivos fast5: ${params.fast5_dir}
    			modelo basecalling: ${params.model}
    			alineador ensamblaje: ${params.aligner} y Nanopolish
    			directorios salida en: ${params.output_dir}
    			"""
    			.stripIndent()

    RUN_GUPPY(fast5)
      }
    }
  }
}
