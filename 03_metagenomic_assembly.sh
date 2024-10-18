#!/usr/bin/env bash

set -e

source config.sh

source /home/parvej/conda/miniconda3/etc/profile.d/conda.sh

conda activate shotgun

mkdir -p ${ASSEMBLY_DIR}

megahit \
    --mem-flag 1 \
    --verbose \
    -1 "${HF_DIR}/${RAW_DATA_FILENAME}_HF.fq.1.gz" \
    -2 "${HF_DIR}/${RAW_DATA_FILENAME}_HF.fq.2.gz" \
    --out-dir "${ASSEMBLY_DIR}" \
    --force

conda deactivate

# default cores - 5m30s
