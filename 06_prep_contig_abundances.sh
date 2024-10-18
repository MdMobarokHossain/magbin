#!/usr/bin/env bash

set -e

source config.sh

./bin/prep_contig_abundances.R \
    -p "${RAW_DATA_FILENAME}" \
    -d "${COUNTS_DIR}"
