#!/bin/bash

BASE_FASTQ=/mnt/results_basecalling/pass
SCHEMES=/home/ins/1_programas/artic-ncov2019/primer_schemes/
b=$1

artic guppyplex --directory ${BASE_FASTQ}/${b} --min-length 400 --max-length 700 --prefix genomes >& ${b}_guppyplex.log

artic minion --medaka --normalise 200 --threads 32 --scheme-directory ${SCHEMES} --read-file genomes_${b}.fastq nCoV-2019/V3 ${b} --bwa >& ${b}_minion.log

