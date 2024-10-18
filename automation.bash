#!/usr/bin/env bash

# Import necessary modules for argument parsing
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Function to display help message
show_help() {
cat << EOF
Usage: ${0##*/} [-r RUN_NAME] [-s SAMPLE_LIST] [-d DATA_LOCATION] [-h]

    -r RUN_NAME        Name of the run directory.
    -s SAMPLE_LIST     Path to the file containing the list of sample names.
    -d DATA_LOCATION   Location of the raw data files.
    -h                 Display this help and exit.
EOF
}

# Parse command line options.
RUN_NAME=""
SAMPLE_LIST=""
DATA_LOCATION=""

while getopts "r:s:d:h" opt; do
    case "$opt" in
    r)  RUN_NAME=$OPTARG
        ;;
    s)  SAMPLE_LIST=$OPTARG
        ;;
    d)  DATA_LOCATION=$OPTARG
        ;;
    h)
        show_help
        exit 0
        ;;
    *)
        show_help >&2
        exit 1
        ;;
    esac
done

# Check if necessary parameters are provided
if [ -z "$RUN_NAME" ] || [ -z "$SAMPLE_LIST" ] || [ -z "$DATA_LOCATION" ]; then
    echo "ERROR: Missing required parameters."
    show_help
    exit 1
fi

# Set working directories
WORK_DIR=$(pwd)
RUN_DIR="${WORK_DIR}/${RUN_NAME}"
RAW_DATA_LOCATION="${DATA_LOCATION}"

# Source config.sh if needed
source config.sh

# Create the necessary directories if they don't exist
mkdir -p "${RUN_DIR}/01-preprocessing" "${RUN_DIR}/02-host-filtered" "${RUN_DIR}/03-assembly" \
"${RUN_DIR}/04-annotation" "${RUN_DIR}/05-quantification" "${RUN_DIR}/06-binning" \
"${RUN_DIR}/07-mag-refinement" "${RUN_DIR}/08-dereplication" "${RUN_DIR}/09-mag-annotation" \
"${RUN_DIR}/10-mag-taxinomic-assignment" "${RUN_DIR}/11-mag-quantification"

# Start processing each sample listed in the provided sample_list.txt file
while read RAW_DATA_FILENAME; do

    echo "Processing sample: $RAW_DATA_FILENAME"

    # Setting up paths for raw data
    export RAW_DATA_FILENAME
    export RAW_DATA_LOCATION="${RAW_DATA_LOCATION}/${RAW_DATA_FILENAME}"

    # Steps of the pipeline
    MSG="STEP 1: TRIMMING"
    echo -e "\n\n${MSG}\n"
    ./bin/01_trimming.sh

    MSG="STEP 2: HOST FILTERING"
    echo -e "\n\n${MSG}\n"
    ./bin/02_host_filter.sh

    MSG="STEP 3: ASSEMBLY"
    echo -e "\n\n${MSG}\n"
    ./bin/03_metagenomic_assembly.sh

    MSG="STEP 4: ANNOTATION"
    echo -e "\n\n${MSG}\n"
    ./bin/04_annotation.sh

    MSG="STEP 5: QUANTIFICATION"
    echo -e "\n\n${MSG}\n"
    ./bin/05_quantification.sh
    ./bin/06_prep_contig_abundances.sh

    MSG="STEP 6: BINNING (MAXBIN)"
    echo -e "\n\n${MSG}\n"
    ./bin/07_binning_maxbin.sh

    MSG="STEP 6: BINNING (METABAT)"
    echo -e "\n\n${MSG}\n"
    ./bin/07_binning_metabat.sh

    MSG="STEP 7: DAS TOOL"
    echo -e "\n\n${MSG}\n"
    ./bin/08_das_tool.sh

    MSG="STEP 8: MAG REFINEMENT"
    echo -e "\n\n${MSG}\n"
    ./bin/09_magpurify.sh

    MSG="STEP 9: MAG EVALUATION USING CHECKM2"
    echo -e "\n\n${MSG}\n"
    ./bin/10_checkm2_mag_evaluation.sh

    MSG="STEP 10: DEREPLICATION"
    echo -e "\n\n${MSG}\n"
    ./bin/11_drep.sh

    MSG="STEP 11: MAG ANNOTATION"
    echo -e "\n\n${MSG}\n"
    ./bin/12_mag_annotation.sh

    MSG="STEP 12: MAG TAXINOMY"
    echo -e "\n\n${MSG}\n"
    ./bin/13_mag_taxinomy_gtdb.sh

    MSG="STEP 13: MAG QUANTIFICATION"
    echo -e "\n\n${MSG}\n"
    ./bin/14_mag_quantification.sh

done < "$SAMPLE_LIST"

echo "Pipeline completed successfully."
