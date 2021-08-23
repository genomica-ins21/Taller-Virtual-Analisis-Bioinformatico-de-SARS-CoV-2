dataset=${PWD}

nextflow run main.nf \
		--fast5_dir = ${dataset}/fast5 \
		--output_dir = . \
		--model = hac \
		--aligner = bwa
		-resume