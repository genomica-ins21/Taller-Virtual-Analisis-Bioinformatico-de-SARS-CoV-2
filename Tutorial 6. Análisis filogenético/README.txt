Selección del modelo:

  iqtree -s aln_secuencias_sinUTRs.fas --seqtype DNA -m TESTONLY

Correr filogenia:

  iqtree -s aln_secuencias_sinUTRs.fas --seqtype DNA -m TIM2+F+I -B 1000
  
Salidas:
  iqtree genera varios archivos, entre ellos los del árbol filogenético en formato newick (archivo .treefile)
  para la sección de visualización debemos descargar este archivo y cambiar su extensión a .nwk
 
Visualizar árbol:

  En microreact.org; crear cuenta gratuita
  En la pestaña UPLOAD cargar le archivo del árbol con extensión .nwk, y cargar el archivo de metadatos
  Pueden explorar el ejemplo interactivo:
    https://microreact.org/project/4eDYoziLscEJhQFF7y6YPB/7f8bf1e8
