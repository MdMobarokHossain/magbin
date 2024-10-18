#!/usr/bin/env bash

set -e

source config.sh

source /home/parvej/conda/miniconda3/etc/profile.d/conda.sh

conda activate gtdbtk-2.1.1

mkdir -p ${MAG_TAX_DIR}/input

ln -sr ${MAG_ANNO_DIR}/*/*.fna ${MAG_TAX_DIR}/input/

gtdbtk \
    classify_wf \
    --genome_dir ${MAG_TAX_DIR}/input \
    --out_dir ${MAG_TAX_DIR} \
    --extension fna \
    --cpus 30

[ -f ${MAG_TAX_DIR}/*.summary.tsv ] && cut -f 2 ${MAG_TAX_DIR}/*.summary.tsv | sed -n '2~1 s/.*s__\(.*\)/\1/p' > ${MAG_TAX_DIR}/tax_classifications.txt
[ -f ${MAG_TAX_DIR}/*.summary.tsv ] && cat ${MAG_TAX_DIR}/*.summary.tsv | sed -n '/;s__\tN\/A/p' | cut -f 1 | sed -n 's/.mp/.mp.fna/p' > ${MAG_TAX_DIR}/tax_unclassified.txt

conda deactivate

# threads 30 - 6m23s
