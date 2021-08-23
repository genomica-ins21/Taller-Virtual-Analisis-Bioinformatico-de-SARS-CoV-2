#!/bin/bash

BASE_FASTQ=/mnt/results_basecalling/pass
SCHEMES=/home/ins/1_programas/artic-ncov2019/primer_schemes/
FAST5_DIR=/mnt/datasets/fast5
SEQSUM=/mnt/results_basecalling/sequencing_summary.txt
b=$1

mkdir /mnt/artic/${b}

cd /mnt/artic/${b}

artic guppyplex --directory ${BASE_FASTQ}/${b} --min-length 400 --max-length 700 --prefix genomes >& ${b}_guppyplex.log

artic minion --normalise 200 --threads 32 --scheme-directory ${SCHEMES} --read-file genomes_${b}.fastq --fast5-directory ${FAST5_DIR} --sequencing-summary ${SEQSUM} nCoV-2019/V3 ${b} --bwa --threads 24 >& ${b}_minion.log

cat ${b}.consensus.fasta >> ../consensus.fasta