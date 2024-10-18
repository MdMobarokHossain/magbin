#!/usr/bin/env bash

set -e

source config.sh

source /home/parvej/conda/miniconda3/etc/profile.d/conda.sh

conda activate shotgun

export CHECKM_DATA_PATH=/home/parvej/programme/checkm_data_2015_01_16

mkdir -p ${DREP_DIR}

checkm \
    lineage_wf \
    ${MAG_REFINEMENT_DIR} \
    ${DREP_DIR}/checkm_output \
    -x ".fa" \
    -f ${DREP_DIR}/checkm1_results.txt \
    -t 30 \
    --pplacer_threads 30 \
    --tab_table

conda deactivate

# threads 30 - 1m48s (incomplete)
