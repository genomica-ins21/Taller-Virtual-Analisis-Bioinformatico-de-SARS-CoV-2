#!/bin/bash

mkdir /mnt/articParallel
cd /mnt/articParallel
echo "***************** ***   Runninng ARTIC pipeline   **************************"
find /mnt/results_basecalling/pass -maxdepth 1 -type d -name barcode* -printf '%f\n' | xargs -n1 -P12 /home/ins/0_scripts/singleParallel.sh
ls /mnt/results_basecalling/pass/ | grep "barcode" > barcodes.txt
