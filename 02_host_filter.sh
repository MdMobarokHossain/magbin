#!/usr/bin/env bash

set -e

source config.sh

source /home/parvej/conda/miniconda3/etc/profile.d/conda.sh

conda activate metagenomics

HOST_DB_HUMAN="/media/parvej/Home3/shotgun/database/GRCh38/Sequence/Bowtie2Index/genome"

mkdir -p ${HF_DIR}

bowtie2 \
    -p 30 \
    -1 "${QC_DIR}/${RAW_DATA_FILENAME}_1_val_1.fq.gz" \
    -2 "${QC_DIR}/${RAW_DATA_FILENAME}_2_val_2.fq.gz" \
    -x "${HOST_DB_HUMAN}" \
    --un-conc-gz "${HF_DIR}/${RAW_DATA_FILENAME}_HF.fq.gz" \
    | samtools view -hbSF4 - > "${HF_DIR}/${RAW_DATA_FILENAME}_HF.bam"

conda deactivate

# threads 30 - 4m2s
