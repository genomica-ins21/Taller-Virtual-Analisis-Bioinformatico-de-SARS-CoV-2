#!/bin/bash

guppy_basecaller -i /home/ins/3_data/testData/fast5/ -s /home/ins/3_data/testData/results_basecalling/ -c dna_r9.4.1_450bps_sup.cfg -m template_r9.4.1_450bps_sup.jsn --barcode_kits "EXP-NBD196" --require_barcodes_both_ends --compress_fastq --trim_barcodes -x "cuda:0,1" --gpu_runners_per_device 24 --num_callers 4 --chunks_per_runner 512 --chunk_size 500
