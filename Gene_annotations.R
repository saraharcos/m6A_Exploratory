#Annotations from hg19 GTF, to get metagene information

library(tidyverse)
library(here)

#read in file
ythdf2_all <- read_tsv(here("GTF annotations", "ythdf2_all_gencodev19"), col_names = FALSE, skip = 2)

#split into two dataframes
ythdf2_peaks <- ythdf2_all[1:3]

ythdf2_annotations <- ythdf2_all[-c(1:3)]

#GenomicRanges
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("GenomicRanges")
library(GenomicRanges)
#test code from vignette

gr <- GRanges(
  seqnames = Rle(c("chr1", "chr2", "chr1", "chr3"), c(1, 3, 2, 4)),
  ranges = IRanges(101:110, end = 111:120, names = head(letters, 10)),
  strand = Rle(strand(c("-", "+", "*", "+", "-")), c(1, 2, 2, 3, 2)),
  score = 1:10,
  GC = seq(1, 0, length=10))
gr
