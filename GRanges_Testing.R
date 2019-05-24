library(tidyverse)
library(here)
library(GenomicRanges)

#test code from vignette

gr <- GRanges(
  seqnames = Rle(c("chr1", "chr2", "chr1", "chr3"), c(1, 3, 2, 4)),
  ranges = IRanges(101:110, end = 111:120, names = head(letters, 10)),
  strand = Rle(strand(c("+", "+", "+", "+", "+")), c(1, 2, 2, 3, 2)),
  score = 1:10,
  GC = seq(1, 0, length=10))
gr


#Generate data files
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
  filter(Peakmutation > 1) %>%
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
  filter(Peakmutation > 1) %>%
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
  filter(Peakmutation > 1) %>%
  select(-Observation_num)


#Make GRanges objects


rep1 <- GRanges(
  seqnames = ythdf2_1$Chromosome,
  ranges = IRanges(start = ythdf2_1$ClusterStart, end = ythdf2_1$ClusterEnd, names = ythdf2_1$`Gene symbol`),
  strand = ythdf2_1$Strand,
  score = ythdf2_1$Peakmutation)

rep2 <- GRanges(
  seqnames = ythdf2_2$Chromosome,
  ranges = IRanges(start = ythdf2_2$ClusterStart, end = ythdf2_2$ClusterEnd, names = ythdf2_2$`Gene symbol`),
  strand = ythdf2_2$Strand,
  score = ythdf2_2$Peakmutation)

rep3 <- GRanges(
  seqnames = ythdf2_3$Chromosome,
  ranges = IRanges(start = ythdf2_3$ClusterStart, end = ythdf2_3$ClusterEnd, names = ythdf2_3$`Gene symbol`),
  strand = ythdf2_3$Strand,
  score = ythdf2_3$Peakmutation)

#Combine (like bedtools merge) reps 1 and 2
gr
reduce(gr)

in_all <- ythdf2_3 %>%
  filter(`Gene symbol` %in% ythdf2_2$`Gene symbol` & `Gene symbol` %in% ythdf2_1$`Gene symbol`)

allGrange <- GRanges(
  seqnames = in_all$Chromosome,
  ranges = IRanges(start = in_all$ClusterStart, end = in_all$ClusterEnd, names = in_all$`Gene symbol`),
  strand = in_all$Strand,
  score = in_all$Peakmutation,
  region = in_all$Region)

head(allGrange)

in_all_bed <- in_all %>% select(Chromosome, ClusterStart, ClusterEnd, Strand)

write_tsv(in_all_bed, here("Peak files", "Test_052419.bed"), col_names = FALSE)



