#!/bin/bash

guppy_basecaller -i /mnt/datasets/fast5/ -s /mnt/results_basecalling/ -c dna_r9.4.1_450bps_hac.cfg -m template_r9.4.1_450bps_hac.jsn --barcode_kits "EXP-NBD196" --require_barcodes_both_ends --compress_fastq --trim_barcodes -x "cuda:0,1" --gpu_runners_per_device 20 --num_callers 4 --chunks_per_runner 1024 --chunk_size 1000
