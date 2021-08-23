params.output_dir = false

process COMBINE_FASTAS {
   input:
      path(fastas)
      path(reference)

   output:
      path("combined.fasta")

   script:
   """
   cp ${reference} combined.fasta
   for f in ${fastas}; do (cat "\${f}"; echo) >> combined.fasta; done
   """
}

process RUN_MINIMAP {
   publishDir "${params.output_dir}/cov_output", 
   mode: 'copy'

   input:
      path(fasta)
      path(reference)
   
   output:
      path('sam/*.sam'), emit: sam_files
      path('sam/*.log')

   script:

   """
   mkdir sam
   minimap2 -a -x asm5 ${reference} ${fasta} -o sam/${fasta}.sam 2> sam/minimap.log

   """
}

process RUN_SAM_2_FASTA {
   publishDir "${params.output_dir}/cov_output", 
   mode: 'copy'

   input:
   path(sam) 
   path(reference)

   output:
   path('mapped_fastas/*.fasta')

   script:

   """
   mkdir mapped_fastas
   datafunk sam_2_fasta -s ${sam} -r ${reference} -o mapped_fastas/${sam}_.fasta --pad --log-inserts --log-deletions
   """
}

process FILTER_COVG_LENGTH {
   publishDir "${params.output_dir}/cov_output", 
   mode: 'copy'

   input:
   path(fasta_file)
   val(min_covg)
   val(min_length)

   output:
   path('fasta_filt/*.fasta')
   
   script:

   """
   mkdir fasta_filt
   datafunk filter_fasta_by_covg_and_length  -i ${fasta_file} -o fasta_filt/${fasta_file}_filt.fasta --min-covg ${min_covg} --min-length ${min_length}

   """
}

process TREE {
   publishDir "${params.output_dir}/cov_output/tree_output", 
   mode: 'copy'

   input:
   path(fasta_filt)
   
   output:
   path('*.tree*')

   script:
   if (params.iqtree) {
   """
   iqtree -s ${fasta_filt} -m GTR+I+G -alrt 1000 -bb 1000 -nm 200 -nt AUTO -ntmax 4

   """
   }
   else { 
   """
   FastTree -gtr -nosupport -nt ${fasta_filt} > out.tree

   """
   }

}

process ROOT_TREE {
   publishDir "${params.output_dir}/cov_output/tree_output", 
   mode: 'copy'

   input:
   path(tree_file)

   output:
   path('rooted_tree.nwk')

   script:
   """
   clusterfunk root --outgroup 'ENA|MN908947|MN908947.3' --in-format newick -i ${tree_file} --out-format newick -o rooted_tree.nwk
   """
}

process LINEAGES_PANGOLIN {
   publishDir "${params.output_dir}/cov_output", 
   mode: 'copy'
   
   input:
   path(fasta_file)

   output:
   path('lineages_pangolin/*.csv')

   script:

   """
   mkdir lineages_pangolin
   pangolin ${fasta_file} --outdir lineages_pangolin/
   """
}

process TYPE_VARIANTS {
   publishDir "${params.output_dir}/cov_output", 
   mode: 'copy'
   
   input:
   path(fasta_file)
   path(config_file)
   path(reference)
   

   output:
   path('type_variants_output/*.csv')

   script:

   """
   mkdir type_variants_output
   type_variants.py --fasta-in ${fasta_file} --variants-config ${config_file} --reference ${reference} --variants-out type_variants_output/output.csv --append-genotypes
   """
}

process MAKE_METADATA {
   publishDir "${params.output_dir}/cov_output/microreact", 
   mode: 'copy'

   input:
      path(user_metadata)
      path(pangolin_output)
      path(type_variants_output)

   output:
      path('combined_metadata.csv')

   script:
   if (workflow.profile == "docker") {
      """
      make_metadata.py ${user_metadata} ${pangolin_output} ${type_variants_output}
      """
   } else {
      """
      ${baseDir}/Docker/scripts/make_metadata.py ${user_metadata} ${pangolin_output} ${type_variants_output}
      """
   }
}

process CREATE_MICROREACT {
   input:
      val(microreact_token)
      path(metadata)
      path(newick_tree)

   output:
      stdout

   script:
   if (workflow.profile == "docker") {
      """
      create_microreact.py ${microreact_token} ${metadata} ${newick_tree}
      """
   } else {
      """
      ${baseDir}/Docker/scripts/create_microreact.py ${microreact_token} ${metadata} ${newick_tree}
      """
   }
}
