#!/usr/bin/local/Rscript

#Script for creating by-replicate bed files for YTHDF2 par-clip. First filter for genes present in all replicates, then write individual peak bed files.

#In excel file:
  #Changed date entries to protein name, referenced from Uniprot
  #In YTHDF2 replicate 2, one gene names was used for 2 different proteins. To address this:
    #TTL, twelve-thirteen translocation leukemia, is removed because no entry found in Uniprot

library(tidyverse)
library(readxl)
library(here)

ythdf2_1 <- read_xlsx(here("Input" ,"GSE49339_A-PARCLIP YTHDF2.xlsx"), 1) %>%
  select("Gene symbol", starts_with("Chromosome"), starts_with("Cluster"), starts_with("Peak mutation"), starts_with("Strand"), starts_with("Region")) %>%
  gather("Observation", "Value", -"Gene symbol") %>%
  na.omit() %>%
  mutate(Observation = gsub(" ", "", Observation)) %>%
  extract(col = Observation, into = c("Data_type", "Observation_num"), regex = "([a-zA-Z]+).{3}([0-9]*)") %>%
  mutate(Observation_num = case_when(
    Data_type == "ClusterStart" ~ as.numeric(Observation_num) -1,
    Data_type == "ClusterEnd" ~ as.numeric(Observation_num) -2,
    Data_type == "Peakmutation" ~ as.numeric(Observation_num) -4,
    Data_type == "Strand" ~ as.numeric(Observation_num) -3,
    Data_type == "Region" ~ as.numeric(Observation_num) -5,
    TRUE ~ as.numeric(Observation_num))) %>%
  spread(Data_type, Value) %>%
  mutate(Peakmutation = as.numeric(Peakmutation),
         ClusterStart = as.numeric(ClusterStart),
         ClusterEnd = as.numeric(ClusterEnd)) %>%
  mutate(Chromosome = str_replace(Chromosome, "CHR", "chr")) %>%
  #filter(Peakmutation > 1) %>%
  select(-Observation_num)

ythdf2_2 <- read_xlsx(here("Input" ,"GSE49339_A-PARCLIP YTHDF2.xlsx"), 2) %>%
  select("Gene symbol", starts_with("Chromosome"), starts_with("Cluster"), starts_with("Peak mutation"), starts_with("Strand"), starts_with("Region")) %>%
  gather("Observation", "Value", -"Gene symbol") %>%
  na.omit() %>%
  mutate(Observation = gsub(" ", "", Observation)) %>%
  extract(col = Observation, into = c("Data_type", "Observation_num"), regex = "([a-zA-Z]+).{3}([0-9]*)") %>%
  mutate(Observation_num = case_when(
    Data_type == "ClusterStart" ~ as.numeric(Observation_num) -1,
    Data_type == "ClusterEnd" ~ as.numeric(Observation_num) -2,
    Data_type == "Peakmutation" ~ as.numeric(Observation_num) -4,
    Data_type == "Strand" ~ as.numeric(Observation_num) -3,
    Data_type == "Region" ~ as.numeric(Observation_num) -5,
    TRUE ~ as.numeric(Observation_num))) %>%
  spread(Data_type, Value) %>%
  mutate(Peakmutation = as.numeric(Peakmutation),
         ClusterStart = as.numeric(ClusterStart),
         ClusterEnd = as.numeric(ClusterEnd)) %>%
  mutate(Chromosome = str_replace(Chromosome, "CHR", "chr")) %>%
  #filter(Peakmutation > 1) %>%
  select(-Observation_num)

ythdf2_3 <- read_xlsx(here("Input" ,"GSE49339_A-PARCLIP YTHDF2.xlsx"), 3) %>%
  select("Gene symbol", starts_with("Chromosome"), starts_with("Cluster"), starts_with("Peak mutation"), starts_with("Strand"), starts_with("Region")) %>%
  gather("Observation", "Value", -"Gene symbol") %>%
  na.omit() %>%
  mutate(Observation = gsub(" ", "", Observation)) %>%
  extract(col = Observation, into = c("Data_type", "Observation_num"), regex = "([a-zA-Z]+).{3}([0-9]*)") %>%
  mutate(Observation_num = case_when(
    Data_type == "ClusterStart" ~ as.numeric(Observation_num) -1,
    Data_type == "ClusterEnd" ~ as.numeric(Observation_num) -2,
    Data_type == "Peakmutation" ~ as.numeric(Observation_num) -4,
    Data_type == "Strand" ~ as.numeric(Observation_num) -3,
    Data_type == "Region" ~ as.numeric(Observation_num) -5,
    TRUE ~ as.numeric(Observation_num))) %>%
  spread(Data_type, Value) %>%
  mutate(Peakmutation = as.numeric(Peakmutation),
         ClusterStart = as.numeric(ClusterStart),
         ClusterEnd = as.numeric(ClusterEnd)) %>%
  mutate(Chromosome = str_replace(Chromosome, "CHR", "chr")) %>%
  #filter(Peakmutation > 1) %>%
  select(-Observation_num)


#write to BED
bed_write <- function(df, name){
  df %>%
    select(Chromosome, ClusterStart, ClusterEnd, Name = `Gene symbol`, Peakmutation, Strand) %>%
    arrange(Chromosome, ClusterStart, ClusterEnd) %>%
    write_tsv(here("Pre-processing beds", paste0(name, '.bed')),
              col_names = FALSE)
}


bed_write(ythdf2_1, "ythdf2_rep1")
bed_write(ythdf2_2, "ythdf2_rep2")
bed_write(ythdf2_3, "ythdf2_rep3")


#For Test 1
merge_reps <- ythdf2_1 %>%
  bind_rows(list(ythdf2_2, ythdf2_3))

bed_write(merge_reps, "ythdf2_allreps")

#Testing if the authors first isolated repeated genes in all 3 replicates, then combined peaks

ythdf2_1_peaks <- ythdf2_1 %>%
  filter(`Gene symbol` %in% ythdf2_2$`Gene symbol` & `Gene symbol` %in% ythdf2_3$`Gene symbol`)

ythdf2_2_peaks <- ythdf2_2 %>%
  filter(`Gene symbol` %in% ythdf2_1$`Gene symbol` & `Gene symbol` %in% ythdf2_3$`Gene symbol`)

ythdf2_3_peaks <- ythdf2_3 %>%
  filter(`Gene symbol` %in% ythdf2_1$`Gene symbol` & `Gene symbol` %in% ythdf2_2$`Gene symbol`)

bed_write(ythdf2_1_peaks, "ythdf2_rep1_bygene")
bed_write(ythdf2_2_peaks, "ythdf2_rep2_bygene")
bed_write(ythdf2_3_peaks, "ythdf2_rep3_bygene")



#Testing overlap analysis using bioconductor ranges. Inspired and adapted from ro-che.info/articles/2018-07-11-chip-seq-consensus
library(rtracklayer)
library(GenomicRanges)
peak_files <- list.files(path = here("Pre-processing beds"), pattern = "bygene")
peak_files <- paste0(here("Pre-processing beds"), "/", peak_files)
peak_files

peak_granges <- lapply(peak_files, import)
peak_granges

peak_grangeslist <- GRangesList(peak_granges)
peak_grangeslist

peak_coverage <- coverage(peak_grangeslist)
peak_coverage

#Add coverage by strand
pcvg <- coverage(peak_grangeslist[strand(peak_grangeslist) == "+"])
mcvg <- coverage(peak_grangeslist[strand(peak_grangeslist) == "-"])

pcovered_ranges <- IRanges::slice(pcvg, lower = 2, rangesOnly = T)
mcovered_ranges <- IRanges::slice(mcvg, lower = 2, rangesOnly = T)

pcovered_granges <- GRanges(pcovered_ranges)
mcovered_granges <- GRanges(mcovered_ranges)

strand(pcovered_granges) = "+"
strand(mcovered_granges) = "-"

#merge peaks that are no more than 1bp apart
preduced <- IRanges::reduce(pcovered_granges, min.gapwidth = 2)
mreduced <- IRanges::reduce(mcovered_granges, min.gapwidth = 2)
all_granges <- c(preduced, mreduced)
all_granges
all_granges[width(all_granges) > 1]

#Now repeat with m6A (doing it in this script for now so I can easily count overlaps without writing to file)





