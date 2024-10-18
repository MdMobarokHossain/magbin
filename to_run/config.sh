#!/usr/bin/env bash

WORK_DIR=$( pwd )
RUN_DIR="${WORK_DIR}/${RUN_NAME}/${RAW_DATA_FILENAME}"
QC_DIR="${RUN_DIR}/01-preprocessing"
HF_DIR="${RUN_DIR}/02-host-filtered"
ASSEMBLY_DIR="${RUN_DIR}/03-assembly"
ANNO_DIR="${RUN_DIR}/04-annotation"
COUNTS_DIR="${RUN_DIR}/05-quantification"
BIN_DIR="${RUN_DIR}/06-binning"
MAG_REFINEMENT_DIR="${RUN_DIR}/07-mag-refinement"
DREP_DIR="${RUN_DIR}/08-dereplication"
MAG_ANNO_DIR="${RUN_DIR}/09-mag-annotation"
MAG_TAX_DIR="${RUN_DIR}/10-mag-taxinomic-assignment"
MAG_COUNTS_DIR="${RUN_DIR}/11-mag-quantification"
