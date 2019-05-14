library(tidyverse)
library(here)


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

#So issue with 1bp sizing happens after this step, during final peak compilation

df2_peaks <- read_tsv(here("Peak files", "ythdf2_peaks_final.bed"), col_names = FALSE) %>%
  mutate(region_length = X3 - X2)

print(paste("Min interval size of df2 peaks: ", min(df2_peaks$region_length)))
print(paste("Max interval size of df2 peaks: ", max(df2_peaks$region_length)))

#Confirmed that peak file has the issue

#Check sort and merge steps

df2_rep1_sort <- read_tsv(here("rep1_bygene_merged.bed"), col_names = FALSE) %>%
  mutate(region_length = X3 - X2)

print(paste("Min interval size of df2 rep1 merged: ", min(df2_rep1_sort$region_length)))
print(paste("Max interval size of df2 rep1 merged: ", max(df2_rep1_sort$region_length)))

#Sort and merge is OK

#Check multi-inter step

df2_multiinter <- read_tsv(here("allreps_multiinter.bed"), col_names = FALSE) %>%
  mutate(region_length = X3 - X2)

print(paste("Min interval size of df2 multiinter: ", min(df2_multiinter$region_length)))
print(paste("Max interval size of df2 multiinter: ", max(df2_multiinter$region_length)))

#ISSUE IS IN MULTIINTER
#Visualize distribution

ggplot(df2_multiinter, aes(x = df2_multiinter$region_length)) +
  geom_bar()


#Try: using intersect instead

df2_intersect_rep1 <- read_tsv(here("rep1_intersected.bed"), col_names = FALSE) %>%
  mutate(region_length = X3 - X2)

print(paste("Min interval size of df2_intersect_rep1: ", min(df2_intersect_rep1$region_length)))
print(paste("Max interval size of df2_intersect_rep1: ", max(df2_intersect_rep1$region_length)))

#Interval size is preserved

#Check final peaks file


df2_peaks <- read_tsv(here("Peak files", "ythdf2_peaks_final.bed"), col_names = FALSE) %>%
  mutate(region_length = X3 - X2)

print(paste("Min interval size of df2 peaks: ", min(df2_peaks$region_length)))
print(paste("Max interval size of df2 peaks: ", max(df2_peaks$region_length)))

#SOLVED!


