#!/usr/bin/local/Rscript

#Script for processing ythdf2 multiinter peaks


library(tidyverse)
library(here)

allreps_multiinter <- read_tsv(here("allreps_multiinter.bed"), col_names = FALSE)

atleast2reps <- allreps_multiinter %>%
  filter(X4 >1 ) 
# %>%
#   mutate(region_length = X3 - X2) %>%
#   filter(region_length >= 9) %>%
#   select(-region_length)

atleast2reps %>%
  select(X1, X2, X3) %>%
  write_tsv(here("2reps_multiinter.bed"), col_names = FALSE)