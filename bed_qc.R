library(tidyverse)
library(here)


df2_peaks <- read_tsv(here("Peak files", "ythdf2_peaks_final.bed"), col_names = FALSE) %>%
  mutate(region_length = X3 - X2)


df2_all <- read_tsv(here("Pre-processing beds", "ythdf2_allreps.bed"), col_names = FALSE) %>%
  mutate(region_length = X3 - X2)

print(paste("Min interval size of df2 all peaks: ", min(df2_all$region_length)))
print(paste("Max interval size of df2 all peaks: ", max(df2_all$region_length)))


df2_rep1 <- read_tsv(here("Pre-processing beds", "ythdf2_rep1_bygene.bed"), col_names = FALSE) %>%
  mutate(region_length = X3 - X2)

print(paste("Min interval size of df2 rep1: ", min(df2_rep1$region_length)))
print(paste("Max interval size of df2 rep1: ", max(df2_rep1$region_length)))

df2_rep2 <- read_tsv(here("Pre-processing beds", "ythdf2_rep2_bygene.bed"), col_names = FALSE) %>%
  mutate(region_length = X3 - X2)

print(paste("Min interval size of df2 rep2: ", min(df2_rep2$region_length)))
print(paste("Max interval size of df2 rep2: ", max(df2_rep2$region_length)))

df2_rep3 <- read_tsv(here("Pre-processing beds", "ythdf2_rep3_bygene.bed"), col_names = FALSE) %>%
  mutate(region_length = X3 - X2)

print(paste("Min interval size of df2 rep3: ", min(df2_rep3$region_length)))
print(paste("Max interval size of df2 rep3: ", max(df2_rep3$region_length)))

#So issue with 1bp sizing happens after this step