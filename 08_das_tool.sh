#!/usr/bin/env bash

set -e

source config.sh

source /home/parvej/conda/miniconda3/etc/profile.d/conda.sh

conda activate das_tool

BIN_DIR_METABAT="${BIN_DIR}/metabat"
BIN_DIR_MAXBIN="${BIN_DIR}/maxbin"

DAS_HOME="/home/parvej/conda/miniconda3/envs/das_tool/share/das_tool-1.1.7-0"
DAS_OUT="${BIN_DIR}/DAS"
mkdir -p $DAS_OUT

Fasta_to_Contig2Bin.sh \
    -e fa \
    -i ${BIN_DIR_METABAT} \
    > ${DAS_OUT}/${RAW_DATA_FILENAME}_metabat.s2b

Fasta_to_Contig2Bin.sh \
    -e fasta \
    -i ${BIN_DIR_MAXBIN} \
    > ${DAS_OUT}/${RAW_DATA_FILENAME}_maxbin.s2b

DAS_Tool \
    -i ${DAS_OUT}/${RAW_DATA_FILENAME}_metabat.s2b,${DAS_OUT}/${RAW_DATA_FILENAME}_maxbin.s2b \
    -c ${ANNO_DIR}/${RAW_DATA_FILENAME}.fna \
    -l ${RAW_DATA_FILENAME}_metabat,${RAW_DATA_FILENAME}_maxbin \
    --write_bin_evals \
    --write_bins \
    --dbDirectory ${DAS_HOME}/db/ \
    -o ${DAS_OUT}/ \
    -t 30 \
    --score_threshold=0.25 \
    --search_engine diamond \
    --debug

conda deactivate

# thread 30 - 9s
