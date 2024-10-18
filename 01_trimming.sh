#!/usr/bin/env bash

set -e

source config.sh

source /home/parvej/conda/miniconda3/etc/profile.d/conda.sh

conda activate trim-galore

mkdir -p ${QC_DIR}

trim_galore \
    --cores 15 \
    --phred33 \
    --length 50 \
    -e 0.1 \
    --2colour 20 \
    --paired \
    --output_dir "${QC_DIR}" \
    --trim-n \
    "${RAW_DATA_LOCATION}/${RAW_DATA_FILENAME}_1.fastq.gz" \
    "${RAW_DATA_LOCATION}/${RAW_DATA_FILENAME}_2.fastq.gz"

conda deactivate

# 15 cores - 1m38s
