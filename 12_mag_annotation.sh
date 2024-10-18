#!/usr/bin/env bash

# set -e

source config.sh

source /home/parvej/conda/miniconda3/etc/profile.d/conda.sh

conda activate annot

mkdir -p ${MAG_ANNO_DIR}

for MAG in ${DREP_DIR}/dereplicated_genomes/*.fa; do
    MAGFILE=`basename ${MAG}`
    MAGPATHBASE=$( echo "${MAG%.*}" )
    awk '/^>/{print ">" ++i; next}{print}' < "$MAG" > "${MAGPATHBASE}_numbered.fa"
    MAG=${MAGFILE%.*}

    locus_tag="MAG"$( md5sum "${MAGPATHBASE}_numbered.fa" | awk '{ print toupper($1) }' | cut -c 1-9 )

    mkdir -p "${MAG_ANNO_DIR}/${MAG}"
    echo -e "${MAG}\t${locus_tag}\n" > "${MAG_ANNO_DIR}/${MAG}/${MAG}.tag"

    prokka \
        --force \
        --outdir "${MAG_ANNO_DIR}/${MAG}" \
        --prefix "${MAG}" \
        --addgenes \
        --locustag "${locus_tag}" \
        --increment 5 \
        --mincontiglen 500 \
        --genus "Mag" \
        --species "mag" \
        --strain "${MAG}" \
        "${MAGPATHBASE}_numbered.fa"
done


conda deactivate

# 13s
