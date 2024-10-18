#!/usr/bin/env bash

set -e

source config.sh

KRAKEN2DB="/media/parvej/Home3/test/gtdb_r89_54k_kraken2_16gb"

ROOT_DIR=$( pwd )
RUN_NAME="noro_shotgun"

FILES=(./runs_${RUN_NAME}/*/10-mag-taxinomic-assignment/tax_unclassified.txt)


for FILE in ${FILES[@]}; do
    echo ${FILE}

    while read UNCLASSIFIED_MAG_FILE; do
        MAG_LOCATION="${FILE%/*}/input/${UNCLASSIFIED_MAG_FILE}"
        echo ${UNCLASSIFIED_MAG_FILE}

        mkdir -p ${FILE%/*}/kraken2

        kraken2 \
            -db ${KRAKEN2DB} \
            -threads 30 \
            --report ${FILE%/*}/kraken2/${UNCLASSIFIED_MAG_FILE}.k2report \
            --use-names \
            ${MAG_LOCATION} \
            --confidence 0.1 \
            --output ${FILE%/*}/kraken2/${UNCLASSIFIED_MAG_FILE}.kraken2

        (
            cd ~/Bracken/ && \
            TAX_ROOT=${FILE%/*}
            bracken \
                -d ${KRAKEN2DB} \
                -i ${ROOT_DIR}/${TAX_ROOT#./}/kraken2/${UNCLASSIFIED_MAG_FILE}.k2report \
                -o ${ROOT_DIR}/${TAX_ROOT#./}/kraken2/${UNCLASSIFIED_MAG_FILE}.bracken
        )
        
    done < ${FILE};

    echo ""
done
