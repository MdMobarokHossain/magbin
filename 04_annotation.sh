#!/usr/bin/env bash

set -e

source config.sh

source /home/parvej/conda/miniconda3/etc/profile.d/conda.sh

conda activate annot

awk '/^>/{print ">" ++i; next}{print}' < "${ASSEMBLY_DIR}/final.contigs.fa" > "${ASSEMBLY_DIR}/contigs_numbered.fa"

locus_tag="META"$( md5sum "${ASSEMBLY_DIR}/contigs_numbered.fa" | awk '{ print toupper($1) }' | cut -c 1-9 )

prefix="${RAW_DATA_FILENAME}"

mkdir -p ${ANNO_DIR}

echo -e "${prefix}\t${locus_tag}\n" > "${ANNO_DIR}/${prefix}.tag"

prokka \
    --force \
    --outdir "${ANNO_DIR}" \
    --prefix "${prefix}" \
    --addgenes \
    --locustag "${locus_tag}" \
    --increment 5 \
    --mincontiglen 500 \
    --genus "Metagenome" \
    --species "metagenome" \
    --strain "${RAW_DATA_FILENAME}" \
    --fast \
    --cpus 0 \
    "${ASSEMBLY_DIR}/contigs_numbered.fa"

conda deactivate

# 3m37s
