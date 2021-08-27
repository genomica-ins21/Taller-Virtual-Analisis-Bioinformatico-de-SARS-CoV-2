Selección del modelo:

  iqtree -s aln_secuencias_sinUTRs.fas --seqtype DNA -m TESTONLY

Correr filogenia:

  iqtree -s aln_secuencias_sinUTRs.fas --seqtype DNA -m TIM2+F+I -B 1000
