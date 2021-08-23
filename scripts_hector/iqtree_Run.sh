#!/bin/bash

inputFile=/home/ins/treev4/mafft_curated_E484K_v4.fas

iqtree -s $inputFile -st DNA -alrt 1000 -m HKY+G4 -nm 100
