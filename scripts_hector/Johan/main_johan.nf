nextflow.enable.dsl=2
params.fasta_file = false
params.output_dir = false
params.iqtree = false
params.config_dir = false
params.min_length = false
params.min_percent_non_Ns = false
params.microreact_metadata = false
params.microreact_access_token = false

if (params.min_length) {
  min_length = params.min_length
} else {
  min_length = 29000
}

if (params.min_percent_non_Ns) {
  min_percent_non_Ns = params.min_percent_non_Ns
} else {
  min_percent_non_Ns = 70
}

// make path to microreact metadata absolute
if (params.microreact_metadata){
  if (! params.microreact_metadata.startsWith("/")) {
      microreact_metadata = "${baseDir}/${params.microreact_metadata}"
  } else {
    microreact_metadata = params.microreact_metadata
  }
}

include { COMBINE_FASTAS; RUN_MINIMAP; RUN_SAM_2_FASTA; FILTER_COVG_LENGTH; TREE; ROOT_TREE; LINEAGES_PANGOLIN; TYPE_VARIANTS; MAKE_METADATA; CREATE_MICROREACT } from './processes/processes'

workflow {
  if (params.fasta_file && params.output_dir) {
    fastas = Channel
      .fromPath(params.fasta_file)
      .ifEmpty { error "Cannot find any reads matching: ${params.fasta_file}" }
    
    COMBINE_FASTAS(fastas.collect(), "${baseDir}/references/MN908947.3.fasta")
    RUN_MINIMAP(COMBINE_FASTAS.out, "${baseDir}/references/MN908947.3.fasta")
    RUN_SAM_2_FASTA(RUN_MINIMAP.out.sam_files, "${baseDir}/references/MN908947.3.fasta")
    FILTER_COVG_LENGTH(RUN_SAM_2_FASTA.out, min_percent_non_Ns, min_length)

    TREE(FILTER_COVG_LENGTH.out)
    ROOT_TREE(TREE.out)
    LINEAGES_PANGOLIN(FILTER_COVG_LENGTH.out)
    TYPE_VARIANTS(FILTER_COVG_LENGTH.out, params.config_dir, "${baseDir}/references/MN908947.3.fasta")
    if (params.microreact_metadata) {
      MAKE_METADATA(microreact_metadata, LINEAGES_PANGOLIN.out, TYPE_VARIANTS.out)
      if (params.microreact_access_token){
        CREATE_MICROREACT(params.microreact_access_token, MAKE_METADATA.out, ROOT_TREE.out)    
        CREATE_MICROREACT.out.view { url -> "Microreact created at $url" } 
      }
    }
  }
}
