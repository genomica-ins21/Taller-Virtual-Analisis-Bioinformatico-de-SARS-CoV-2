#!/bin/bash

##source activate artic-ncov19

cd /mnt/articMinimap
ls /mnt/results_basecalling/ | grep "barcode" > barcodes.txt
filename="/mnt/articMinimap/barcodes.txt"
while read -r line;  do
	barcode="$line"
        mkdir /mnt/articMinimap/${barcode}
        cd /mnt/articMinimap/${barcode}
        ~/0_scripts/singleMinimapped.sh "${barcode}"
	cd /mnt/articMinimap/
	cat /mnt/articMinimap/${barcode}/${barcode}.consensus.fasta >> /mnt/articMinimap/consensus_genomes.fasta
done < "$filename"
