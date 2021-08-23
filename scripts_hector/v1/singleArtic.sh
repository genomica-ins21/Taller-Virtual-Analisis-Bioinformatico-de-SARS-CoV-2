#!/bin/bash

BASE_FASTQ=/mnt/results_basecalling
SCHEMES=/home/ins/artic-ncov2019/primer_schemes/
FAST5_DIR=/mnt/datasets/fast5
SEQSUM=/mnt/results_basecalling/sequencing_summary.txt
b=$1

artic guppyplex --directory ${BASE_FASTQ}/${b} --min-length 400 --max-length 700 --prefix genomes >& ${b}_guppyplex.log

artic minion --normalise 200 --threads 32 --scheme-directory ${SCHEMES} --read-file genomes_${b}.fastq --fast5-directory ${FAST5_DIR} --sequencing-summary ${SEQSUM} nCoV-2019/V3 ${b} --bwa >& ${b}_minion.log

