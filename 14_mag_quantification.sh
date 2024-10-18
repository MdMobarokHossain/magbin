#!/usr/bin/env bash

set -e

source config.sh

source /home/parvej/conda/miniconda3/etc/profile.d/conda.sh

conda deactivate

mkdir -p ${MAG_COUNTS_DIR}/index_input/
mkdir -p ${MAG_COUNTS_DIR}/kallisto_output

ln -srf ${MAG_ANNO_DIR}/*/*.fna ${MAG_COUNTS_DIR}/index_input/

if [ ! -f ${MAG_COUNTS_DIR}/${RAW_DATA_FILENAME}.kallisto ]; then
    kallisto \
        index \
        -i ${MAG_COUNTS_DIR}/${RAW_DATA_FILENAME}.kallisto \
        --make-unique \
        ${MAG_COUNTS_DIR}/index_input/*.fna
fi

# 9s

kallisto \
    quant \
    -b 100 \
    -i ${MAG_COUNTS_DIR}/${RAW_DATA_FILENAME}.kallisto \
    -o ${MAG_COUNTS_DIR}/kallisto_output/ \
    -t 30 \
    "${HF_DIR}/${RAW_DATA_FILENAME}_HF.fq.1.gz" \
    "${HF_DIR}/${RAW_DATA_FILENAME}_HF.fq.2.gz"

# threads 30 - 31s
