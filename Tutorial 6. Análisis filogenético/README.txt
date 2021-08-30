Activar el módulo de iqtree
  
  conda activate iqtree

Selección del modelo:

  iqtree -s aln_secuencias_sinUTRs.fas --seqtype DNA -m TESTONLY

Correr filogenia:

  iqtree -s aln_secuencias_sinUTRs.fas --seqtype DNA -m TIM2+F+I -B 1000
 
Visualizar árbol:

  En microreact.org; crear cuenta gratuita
  En la pestaña UPLOAD cargar le archivo del árbol con extensión .nwk, y cargar el archivo de metadatos
  Pueden explorar el ejemplo interactivo:
    https://microreact.org/project/4eDYoziLscEJhQFF7y6YPB/7f8bf1e8
