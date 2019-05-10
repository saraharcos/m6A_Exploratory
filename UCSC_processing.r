#Output from UCSC data integrator, NCBI refseq genes overlapped with ythdf2_vennexclusive.bed

library(tidyverse)
library(here)

#YTHDF2 exclusive
ythdf2_exclusive <- read_tsv(here("GO files", "ythdf2_exclusive_NCBIrefseq_041619"), skip = 1) %>%
  select(ncbiRefSeq.name2) %>%
  unique()

#save to file for GO analysis
write_tsv(ythdf2_exclusive, here("GO files", "ythdf2_exclusive.tsv"), col_names = FALSE)


#YTHDF2 venncenter
ythdf2_venncenter <- read_tsv(here("GO files", "ythdf2_venncenter_NCBIrefseq_041619"), skip = 1) %>%
  select(ncbiRefSeq.name2) %>%
  unique()

#save to file for GO analysis
write_tsv(ythdf2_venncenter, here("GO files", "ythdf2_venncenter.tsv"), col_names = FALSE)


#YTHDF2 all
ythdf2_all <- read_tsv(here("GO files", "ythdf2_all_NCBIrefseq_041619"), skip = 1) %>%
  select(ncbiRefSeq.name2) %>%
  unique()

#save to file for GO analysis
write_tsv(ythdf2_all, here("GO files", "ythdf2_all.tsv"), col_names = FALSE)

#m6A exclusive
m6A_exclusive <- read_tsv(here("GO files", "m6A_exclusive_NCBIrefseq_041619"), skip = 1) %>%
  select(ncbiRefSeq.name2) %>%
  unique()

#save to file for GO analysis
write_tsv(m6A_exclusive, here("GO files", "m6A_exclusive.tsv"), col_names = FALSE)


#m6A venncenter
m6A_venncenter <- read_tsv(here("GO files", "m6A_venncenter_NCBIrefseq_041619"), skip = 1) %>%
  select(ncbiRefSeq.name2) %>%
  unique()

#save to file for GO analysis
write_tsv(m6A_venncenter, here("GO files", "m6A_venncenter.tsv"), col_names = FALSE)


#m6A all
m6A_all <- read_tsv(here("GO files", "m6A_all_NCBIrefseq_041619"), skip = 1) %>%
  select(ncbiRefSeq.name2) %>%
  unique()

#save to file for GO analysis
write_tsv(m6A_all, here("GO files", "m6A_all.tsv"), col_names = FALSE)
