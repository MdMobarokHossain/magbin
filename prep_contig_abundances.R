#!/usr/bin/env Rscript

# Purpose: Consolidate the Kallisto results for all results/samples from a subgroup

# This script was derived from kallisto_contig_abundance_to_metabat_table_single.R
# It contains additional comments intended to make it easier for the reader to
# follow the script's actions, inputs, outputs, etc.

# Edit requests for future:
# -Substitute "subgroups" for "participants" to make script more generalizeable to diff. use cases

library(optparse)
library(tidyverse)
library(rhdf5)
library(matrixStats)

setwd("./")

# Arguments ---------------------------------------------------------------

option_list = list(
  make_option(c("-p", "--pid"), type="character", default=NULL,
              help="single participant id", dest="pid"),
  make_option(c("-d", "--dir"), type="character", default="05_quantification",
              help="kallisto contig quantification directory [default = %default]", dest="CONTIG_COUNTS_DIR")
);

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

if (is.null(opt$pid)){
  print_help(opt_parser)
  stop("Must supply participant ID\n", call.=FALSE)
}

#Output command line arguments:
print(paste("PID list: ", opt$pid))
print(paste("Contig quantification directory:", opt$CONTIG_COUNTS_DIR))

# custom functions
tpm <- function(counts, effLen) {
  rate <- log(counts) - log(effLen)
  denom <- log(sum(exp(rate)))
  exp(rate - denom + log(1E6))
}

# Recursively search for all instances of "abundance.h5" (each result file will be in a folder named by SID)
files <- list.files(path=opt$CONTIG_COUNTS_DIR, pattern="abundance.h5", full.names = TRUE, recursive = TRUE)
print(paste0(opt$CONTIG_COUNTS_DIR, "/", opt$pid, "_"))

# Select the subset of files corresponding to the subgroup being considered
files.sub <- files[grepl(paste0(opt$CONTIG_COUNTS_DIR), files)]

if (length(files.sub) == 0) {
  stop("[ERROR] No files found!")
} else {
  print(paste("[STATUS] Will process", length(files.sub), "files belonging to subgroup: ", opt$pid))
}

SID_array <- NA

res <- data.frame() # "res" for "results"?

# Kallisto abundance.h5 file structure:
# aux                 (group)
#   bias_normalized   (dataset)
#   bias_observed     (dataset)
#   call              (dataset)
#   eff_lengths       (dataset) -- effective length of contigs (1 column)
#   fld               (dataset)
#   ids               (dataset) -- contig names (1 column)
#   index_version     (dataset)
#   kallisto_version  (dataset)
#   lengths           (dataset) -- length of contigs (1 column)
#   num_bootstrap     (dataset)
#   num_processed     (dataset)
#   start_time        (dataset)
# bootstrap           (group)   -- contains n datasets; each is a bootstrapping result (1 column ea.)
# est_counts          (dataset) 

# For each file/sample associated with this subgroup...
for (j in 1:length(files.sub)) {
  print(paste(j, "/", length(files.sub), "files"))
  # SID <- gsub(paste0(opt$CONTIG_COUNTS_DIR, "/"), "", dirname(files.sub[j]))
  SID <- opt$pid
  # For a particular file, for example:
  #    /scratch/jglab/nmcnulty/analysis_test/06_contig_quantification/MDZHS5_FDR017_D11/abundance.h5
  # 1) Append "/" to the folder where all Kallisto results are stored:
     # /scratch/jglab/nmcnulty/analysis_test/06_contig_quantification => /scratch/jglab/nmcnulty/analysis_test/06_contig_quantification/
  # 2) Get the name of the directory where the current file is stored:
     # /scratch/jglab/nmcnulty/analysis_test/06_contig_quantification/MDZHS5_FDR017_D11
  # 3) Replace the string in #1 with "" in the string in #2, leaving nothing but the SID:
     # MDZHS5_FDR017_D11	
  if (is.na(SID_array[1])) {
    SID_array <- SID
  } else {
    SID_array <- c(SID_array, SID)
  }
  
  # Store all bootstrapping data for this sample/.h5 file as a list of numeric vectors
  boot_array <- h5read(files.sub[j], "bootstrap")

  # Start the bootstrapping data frame by consolidating 3 datasets (1 column each) from this .h5 file
  df_boot <- data.frame(contigName = h5read(files.sub[j], "aux/ids"),
                        contigLen = h5read(files.sub[j], "aux/lengths"),
                        contigEffLen = h5read(files.sub[j], "aux/eff_lengths"))
  
  # If this is the first sample of the subgroup, grab the contigName and contigLen columns as a starting
  # point for building the aggregate data frame
  if (length(res) == 0) {
    res <- df_boot %>%
      select(-contigEffLen)
  }

  # For each bootstrapping result in the boot_array list
  for (k in 1:length(boot_array)) {
    print(paste(k, "/", length(boot_array), "bootstraps"))
    name <- paste0("bs", k - 1) # bootstrap results numbering starts at 0 in .h5 file (datasets named "bs0", "bs1", etc.) 
    df_boot <- df_boot %>%
      # TPM normalize each column of bootstrapping results and add new column of counts to the growing data frame
      bind_cols(data.frame(tpm(boot_array[[k]], df_boot$contigEffLen)) %>% rename(!!name := 1))
  }
  
  # Read in the abundance.tsv file for the SID (stored in the same folder as the .h5 file) as a data frame
  res_kallisto <- read.table(paste0(opt$CONTIG_COUNTS_DIR, "/abundance.tsv"), sep = "\t", header = TRUE)
  
  # Kallisto abundance.tsv file structure (header and first data row as example):
  # target_id       length  eff_length      est_counts      tpm
  # k141_175512     307     142.777 0       0

  if (!all(df_boot$contigName == res_kallisto$target_id)) {
    stop()
  }
  
  res_sub <- data.frame(ab = res_kallisto$tpm,
                        #                          mean_boot = rowMeans(df_boot %>% select(-contigName, -contigLen, -contigEffLen)),
                        # Calculate row-wise variance for each contig (row) from TPM-normalized bootstrapping results
			var = rowVars(as.matrix(df_boot %>% select(-contigName, -contigLen, -contigEffLen))),
                        contigName = df_boot$contigName,
                        contigLen = df_boot$contigLen)
  colnames(res_sub)[colnames(res_sub) == "ab"] <- SID
  colnames(res_sub)[colnames(res_sub) == "var"] <- paste0(SID, "-var")
  
  res <- res %>%
     full_join(res_sub, by = c("contigName", "contigLen"))
}

res <- res %>%
  # all_of() is for strict selection. If any of the variables in the character vector is missing, an error is thrown.
  select(all_of(SID_array)) %>%
  # transmute() creates new columns and removes previously existing columns
  transmute(totalAvgDepth = rowSums(.)) %>%
  bind_cols(res) %>%
  relocate(totalAvgDepth, .after = contigLen)

write.table(res, paste0(opt$CONTIG_COUNTS_DIR, "/", opt$pid, "_kallisto.depth"), sep = "\t", quote = F, row.names = F)
