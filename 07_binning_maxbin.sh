#!/usr/bin/env bash

set -e

source config.sh

source /home/parvej/conda/miniconda3/etc/profile.d/conda.sh

conda activate gtdbtk-2.1.1

./bin/depth_table_to_file.py -i ${COUNTS_DIR}/${RAW_DATA_FILENAME}_kallisto.depth -p ${COUNTS_DIR}

mkdir -p ${BIN_DIR}/maxbin

run_MaxBin.pl \
    -contig ${ANNO_DIR}/${RAW_DATA_FILENAME}.fna \
    -out ${BIN_DIR}/maxbin/${RAW_DATA_FILENAME}_bin \
    -abund_list ${COUNTS_DIR}/${RAW_DATA_FILENAME}_kallisto.depth_list \
    -thread 30 \
    -min_contig_length 1000 \
    -max_iteration 5 \
    -prob_threshold 0.8 \
    -plotmarker \
    -markerset 20

conda deactivate

# thread 30 - 12s
