#!/usr/bin/env bash

set -e

source config.sh

source /home/parvej/conda/miniconda3/etc/profile.d/conda.sh

conda activate checkm2

export CHECKM2DB="/media/parvej/Home3/shotgun/database/checkm_database/CheckM2_database/uniref100.KO.1.dmnd"

mkdir -p ${DREP_DIR}

checkm2 \
    predict \
    --input ${MAG_REFINEMENT_DIR} \
    --extension ".fa" \
    --output-directory ${DREP_DIR}/checkm2_output \
    --threads 30 \
    --force

conda deactivate

# threads 30 - 45s
