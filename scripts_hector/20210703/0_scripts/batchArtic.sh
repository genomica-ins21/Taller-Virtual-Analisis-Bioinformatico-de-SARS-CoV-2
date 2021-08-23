#!/bin/bash

##source activate artic-ncov19

cd /mnt/artic
ls /mnt/results_basecalling/pass/ | grep "barcode" > barcodes.txt
filename="/mnt/artic/barcodes.txt"
while read -r line;  do
	barcode="$line"
        mkdir /mnt/artic/${barcode}
        cd /mnt/artic/${barcode}
        ~/0_scripts/singleArtic.sh "${barcode}"
	cd /mnt/artic/
	cat /mnt/artic/${barcode}/${barcode}.consensus.fasta >> /mnt/artic/consensus_genomes.fasta
done < "$filename"
