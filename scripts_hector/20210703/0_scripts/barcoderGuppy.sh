#!/bin/bash
guppy_barcoder -i /mnt/datasets/fastq/ -s /mnt/results_barcoding/ --barcode_kits "EXP-NBD196" --require_barcodes_both_ends --trim_barcodes -t 24 -x "cuda:0,1" --num_barcoding_buffers 64
