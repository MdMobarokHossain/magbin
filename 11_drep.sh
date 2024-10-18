#!/usr/bin/env bash

set -e

source config.sh

source /home/parvej/conda/miniconda3/etc/profile.d/conda.sh

conda activate drep

export CHECKM_DATA_PATH=/home/parvej/programme/checkm_data_2015_01_16

mkdir -p ${DREP_DIR}

# [ ! -f ${DREP_DIR}/checkm2_results.csv ] && echo "genome,completeness,contamination" >> ${DREP_DIR}/checkm2_results.csv && cut -f 1,2,3 ${DREP_DIR}/checkm2_output/quality_report.tsv | grep -v "^Name" | sed 's/\t/,/g' | sed 's/.mp/.mp.fa/g' >> ${DREP_DIR}/checkm2_results.csv
[ ! -f ${DREP_DIR}/checkm2_results.csv ] \
&& cut -f 1,2,3 ${DREP_DIR}/checkm2_output/quality_report.tsv \
| sed -e 's/\t/,/g' -e 's/.mp,/.mp.fa,/g' -e '/^Name/a genome,completeness,contamination'\
| grep -v "^Name" \
> ${DREP_DIR}/checkm2_results.csv

ls ${MAG_REFINEMENT_DIR}/*.fa > ${DREP_DIR}/MAGS_FOR_DEREPLICATION.txt

dRep dereplicate \
    ${DREP_DIR} \
    -g ${DREP_DIR}/MAGS_FOR_DEREPLICATION.txt \
    -p 30 \
    -l 50000 \
    --completeness 60 \
    --contamination 26 \
    --S_algorithm ANImf \
    --P_ani 0.7 \
    --S_ani 0.7 \
    --cov_thresh 0.1 \
    --genomeInfo ${DREP_DIR}/checkm2_results.csv

conda deactivate

# threads 30 - 3s (with checkm results) - 2m36s (without checkm results)
