#!/usr/bin/env bash

set -e

source config.sh

source /home/parvej/conda/miniconda3/etc/profile.d/conda.sh

conda activate shotgun

mkdir -p ${BIN_DIR}/metabat

metabat2 \
    --unbinned \
    --saveCls \
    --inFile ${ANNO_DIR}/${RAW_DATA_FILENAME}.fna \
    --outFile ${BIN_DIR}/metabat/${RAW_DATA_FILENAME}_bin \
    --abdFile ${COUNTS_DIR}/${RAW_DATA_FILENAME}_kallisto.depth \
    --maxP 70 \
    --maxEdges 100 \
    -s 20000 \
    -v

conda deactivate

# 1.5s

mkdir -p ${BIN_DIR}/metabat/misc/

[ -f ${BIN_DIR}/metabat/${RAW_DATA_FILENAME}_bin ] && mv ${BIN_DIR}/metabat/${RAW_DATA_FILENAME}_bin ${BIN_DIR}/metabat/misc/
[ -f ${BIN_DIR}/metabat/${RAW_DATA_FILENAME}_bin.lowDepth.fa ] && mv ${BIN_DIR}/metabat/${RAW_DATA_FILENAME}_bin.lowDepth.fa ${BIN_DIR}/metabat/misc/
[ -f ${BIN_DIR}/metabat/${RAW_DATA_FILENAME}_bin.tooShort.fa ] && mv ${BIN_DIR}/metabat/${RAW_DATA_FILENAME}_bin.tooShort.fa ${BIN_DIR}/metabat/misc/
[ -f ${BIN_DIR}/metabat/${RAW_DATA_FILENAME}_bin.unbinned.fa ] && mv ${BIN_DIR}/metabat/${RAW_DATA_FILENAME}_bin.unbinned.fa ${BIN_DIR}/metabat/misc/
