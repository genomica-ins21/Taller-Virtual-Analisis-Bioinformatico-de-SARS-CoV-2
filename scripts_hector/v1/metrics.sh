#!/bin/bash

## directorio artic con barcodes a procesar
articPath="$1"

# parametro archivo salida
output_file="$2"

filename="${articPath}/barcodes.txt"

mkdir metrics_Temp
cd metrics_Temp

printf "%b" "Barcode;bases;Avg.depth" >> $output_file
while read -r line; do
    Barcode="$line"

    bwa index -p $Barcode ${articPath}/${Barcode}/${Barcode}.consensus.fasta	#construcción del índice

    bwa mem $Barcode ${articPath}/${Barcode}/genomes_${Barcode}.fastq > aln_${Barcode}.sam 		#alineamiento de fastq a secuencia consenso

    samtools view -S -b aln_${Barcode}.sam > aln_${Barcode}.bam 		#pasar a bam

	samtools sort aln_${Barcode}.bam -o aln_${Barcode}-sorted.bam 		#sorting

	numero_bases=$(samtools mpileup aln_${Barcode}-sorted.bam | awk -v X="${MIN_COVERAGE_DEPTH}" '$4>=X' | wc -l)

	promedio_soporte=$(samtools depth aln_${Barcode}-sorted.bam | awk '{sum+=$3} END {print sum/NR}')

	printf "%b" "\n${Barcode};${numero_bases};${promedio_soporte}" >> $output_file

done < "$filename"

cd ..
rm -r ./metrics_Temp
