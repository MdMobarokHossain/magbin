#!/usr/bin/env bash

while read RAW_DATA_FILENAME; do

	# RAW_DATA_LOCATION="/media/parvej/Home3/CHAIN_Bangladesh/${RAW_DATA_FILENAME}/1_RawData"
	RAW_DATA_LOCATION="/media/parvej/My_Book/BIRDEM/Merged_Samples"

	export RAW_DATA_FILENAME
	export RAW_DATA_LOCATION

	MSG="    STEP 1: TRIMMING    "
	MSG_LENGTH=$(( ${#MSG} ))
	echo -e "\n\n"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n${MSG}"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n\n"
	./bin/01_trimming.sh # 1m38s

	MSG="    STEP 2: HOST FILTERING    "
	MSG_LENGTH=$(( ${#MSG} ))
	echo -e "\n\n"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n${MSG}"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n\n"
	./bin/02_host_filter.sh # 4m2s

	MSG="    STEP 3: ASSEMBLY    "
	MSG_LENGTH=$(( ${#MSG} ))
	echo -e "\n\n"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n${MSG}"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n\n"
	./bin/03_metagenomic_assembly.sh # 5m30s

	MSG="    STEP 4: ANNOTATION    "
	MSG_LENGTH=$(( ${#MSG} ))
	echo -e "\n\n"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n${MSG}"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n\n"
	./bin/04_annotation.sh # 3m37s

	MSG="    STEP 5: QUANTIFICATION    "
	MSG_LENGTH=$(( ${#MSG} ))
	echo -e "\n\n"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n${MSG}"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n\n"
	./bin/05_quantification.sh # 31s (index) 15s (quant)

	./bin/06_prep_contig_abundances.sh

	MSG="    STEP 6: BINNING (PART 1 - MAXBIN)    "
	MSG_LENGTH=$(( ${#MSG} ))
	echo -e "\n\n"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n${MSG}"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n\n"
	./bin/07_binning_maxbin.sh # 12s

	MSG="    STEP 6: BINNING (PART 2 - METABAT)    "
	MSG_LENGTH=$(( ${#MSG} ))
	echo -e "\n\n"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n${MSG}"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n\n"
	./bin/07_binning_metabat.sh # 1.5s

	MSG="    STEP 7: DAS TOOL    "
	MSG_LENGTH=$(( ${#MSG} ))
	echo -e "\n\n"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n${MSG}"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n\n"
	./bin/08_das_tool.sh # 9s

	MSG="    STEP 8: MAG REFINEMENT    "
	MSG_LENGTH=$(( ${#MSG} ))
	echo -e "\n\n"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n${MSG}"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n\n"
	./bin/09_magpurify.sh # 1m45s

	# MSG="    STEP 9: MAG EVALUATION USING CHECKM    "
	# MSG_LENGTH=$(( ${#MSG} ))
	# echo -e "\n\n"
	# printf "=%.0s" $( seq ${MSG_LENGTH} )
	# echo -e "\n${MSG}"
	# printf "=%.0s" $( seq ${MSG_LENGTH} )
	# echo -e "\n\n"
	# ./bin/10_checkm_mag_evaluation.sh # 1m48s

	MSG="    STEP 9: MAG EVALUATION USING CHECKM2    "
	MSG_LENGTH=$(( ${#MSG} ))
	echo -e "\n\n"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n${MSG}"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n\n"
	./bin/10_checkm2_mag_evaluation.sh # 45s

	MSG="    STEP 10: DEREPLICATION    "
	MSG_LENGTH=$(( ${#MSG} ))
	echo -e "\n\n"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n${MSG}"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n\n"
	./bin/11_drep.sh # 3s (2m45s without checkm results)

	MSG="    STEP 11: MAG ANNOTATION    "
	MSG_LENGTH=$(( ${#MSG} ))
	echo -e "\n\n"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n${MSG}"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n\n"
	./bin/12_mag_annotation.sh # 13s

	MSG="    STEP 12: MAG TAXINOMY    "
	MSG_LENGTH=$(( ${#MSG} ))
	echo -e "\n\n"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n${MSG}"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n\n"
	./bin/13_mag_taxinomy_gtdb.sh # 6m23s

	MSG="    STEP 13: MAG QUANTIFICATION    "
	MSG_LENGTH=$(( ${#MSG} ))
	echo -e "\n\n"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n${MSG}"
	printf "=%.0s" $( seq ${MSG_LENGTH} )
	echo -e "\n\n"
	./bin/14_mag_quantification.sh # 9s (index) 31s (quant)

done < sample_list.txt
