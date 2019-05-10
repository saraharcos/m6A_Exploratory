#Annotations from hg19 GTF, to get metagene information

library(tidyverse)
library(here)


m6A_all <- read_tsv(here("GTF annotations", "m6A_all_named"), col_names = FALSE)

test <- m6A_all %>% select(X13) %>%
  filter(grepl("ENSG00000000457", X13))

write_tsv(test, here("GTF annotations", "test.txt"))
