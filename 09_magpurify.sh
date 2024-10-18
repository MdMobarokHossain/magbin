#!/usr/bin/env bash

set -e

source config.sh

source /home/parvej/conda/miniconda3/etc/profile.d/conda.sh

conda activate shotgun

export MAGPURIFYDB="/media/parvej/Home3/shotgun/database/MAGpurify-db-v1.0"

DAS_OUT="${BIN_DIR}/DAS"

mkdir -p ${MAG_REFINEMENT_DIR}/

for MAG_FILE in ${DAS_OUT}/*_DASTool_bins/*.fa; do
    MAG_OUT=$(basename ${MAG_FILE} ".fa")
    TMP_DIR=${MAG_REFINEMENT_DIR}/tmp/${MAG_OUT}_magpurify

    mkdir -p $TMP_DIR

    magpurify \
        phylo-markers \
        --threads 30 \
        $MAG_FILE \
        $TMP_DIR

    magpurify \
        clade-markers \
        --threads 30 \
        $MAG_FILE \
        $TMP_DIR

    magpurify \
        tetra-freq \
        $MAG_FILE \
        $TMP_DIR

    magpurify \
        gc-content \
        $MAG_FILE \
        $TMP_DIR

    magpurify \
        clean-bin \
        $MAG_FILE \
        $TMP_DIR \
        ${MAG_REFINEMENT_DIR}/${MAG_OUT}.mp.fa

    if [ -e "${MAG_REFINEMENT_DIR}/${MAG_OUT}.mp.fa" ]; then
        rm -r $TMP_DIR
    fi
done

# for MAG_FILE in ${BIN_DIR}/metabat/*.fa; do
#     MAG_OUT=$(basename ${MAG_FILE} ".fa")
#     TMP_DIR=${MAG_REFINEMENT_DIR}/tmp/${MAG_OUT}_magpurify

#     mkdir -p $TMP_DIR

#     magpurify \
#         phylo-markers \
#         --threads 30 \
#         $MAG_FILE \
#         $TMP_DIR

#     magpurify \
#         clade-markers \
#         --threads 30 \
#         $MAG_FILE \
#         $TMP_DIR

#     magpurify \
#         tetra-freq \
#         $MAG_FILE \
#         $TMP_DIR

#     magpurify \
#         gc-content \
#         $MAG_FILE \
#         $TMP_DIR

#     magpurify \
#         clean-bin \
#         $MAG_FILE \
#         $TMP_DIR \
#         ${MAG_REFINEMENT_DIR}/${MAG_OUT}.mp.fa

#     if [ -e "${MAG_REFINEMENT_DIR}/${MAG_OUT}.mp.fa" ]; then
#         rm -r $TMP_DIR
#     fi
# done

conda deactivate

# threads 30 - 1m45s

rm -r ${MAG_REFINEMENT_DIR}/tmp
