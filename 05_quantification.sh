#!/usr/bin/env bash

set -e

source config.sh

source /home/parvej/conda/miniconda3/etc/profile.d/conda.sh

conda deactivate

mkdir -p ${COUNTS_DIR}

if [ ! -f ${ANNO_DIR}/${RAW_DATA_FILENAME}.kallisto ]; then
    kallisto \
        index \
        -i ${ANNO_DIR}/${RAW_DATA_FILENAME}.kallisto \
        ${ANNO_DIR}/${RAW_DATA_FILENAME}.fna
fi

# 31s

kallisto \
    quant \
    -b 100 \
    -i ${ANNO_DIR}/${RAW_DATA_FILENAME}.kallisto \
    -o ${COUNTS_DIR} \
    -t 30 \
    "${HF_DIR}/${RAW_DATA_FILENAME}_HF.fq.1.gz" \
    "${HF_DIR}/${RAW_DATA_FILENAME}_HF.fq.2.gz"

# threads 30 - 15s
