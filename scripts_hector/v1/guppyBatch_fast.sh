#!/bin/bash

fast5Input=/mnt/datasets/fast5/
fastQoutput=/mnt/results_fast/

guppy_basecaller -i "$fast5Input" -s "$fastQoutput" -c dna_r9.4.1_450bps_fast.cfg -m template_r9.4.1_450bps_fast.jsn --barcode_kits "EXP-NBD196" --require_barcodes_both_ends --compress_fastq --trim_barcodes -x "cuda:0,1" --gpu_runners_per_device 20 --num_callers 4 --chunks_per_runner 1024 --chunk_size 1000
