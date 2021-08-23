#!/bin/bash

## [1]: path to multi-fasta sequences file of genomes to align
## [2]: output file path

reference=/home/ins/2_defaults/Wuhan-Hu-1_reference.fasta
sequences=$1
output=$2

/home/ins/1_programas/bin/mafft --6merpair --thread -1 --maxambiguous 0.9 --addfragments $sequences $reference > $output

