#!/bin/bash

cd /mnt/artic
find /mnt/results_basecalling/pass -type d -name barcode* -maxdepth 1 | grep -o .........$ | xargs -P 12 /home/ins/0_scripts/singleParallel.sh
cat $(find /mnt/artic/ -name *.consensus.fasta) > /mnt/artic/consensus_genomes.fasta
 