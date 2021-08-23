#!/bin/bash

##source activate artic-ncov19

cd /mnt/medaka
ls /mnt/results_basecalling/pass | grep "barcode" > barcodes.txt
filename="/mnt/medaka/barcodes.txt"
while read -r line;  do
	barcode="$line"
        mkdir /mnt/medaka/${barcode}
        cd /mnt/medaka/${barcode}
        ~/0_scripts/singleMedaka.sh "${barcode}"
	cd /mnt/medaka/
	cat /mnt/medaka/${barcode}/${barcode}.consensus.fasta >> /mnt/medaka/consensus_genomes.fasta
done < "$filename"
