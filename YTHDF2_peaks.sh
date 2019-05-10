#!/bin/bash

echo "Step 0: read each replicate from the excel into R, then output bed files of peaks filtered for genes that appear in all 3 replicates only."

Rscript DF2_parclip_peakstobed.R

echo "Step 1: sort the bed files for each replicate"

bedtools sort -i Pre-processing\ beds/ythdf2_rep1_bygene.bed > rep1_bygene_sorted.bed
bedtools sort -i Pre-processing\ beds/ythdf2_rep2_bygene.bed > rep2_bygene_sorted.bed
bedtools sort -i Pre-processing\ beds/ythdf2_rep3_bygene.bed > rep3_bygene_sorted.bed

echo "Step 2: merge the bed files for each replicate"

bedtools merge -i rep1_bygene_sorted.bed | uniq > rep1_bygene_merged.bed
bedtools merge -i rep2_bygene_sorted.bed | uniq > rep2_bygene_merged.bed
bedtools merge -i rep3_bygene_sorted.bed | uniq > rep3_bygene_merged.bed

echo "Step 3: use multiinter command to calculate peak intersections"

bedtools multiinter -i rep1_bygene_merged.bed rep2_bygene_merged.bed rep3_bygene_merged.bed | uniq > allreps_multiinter.bed

echo "Step 4: use R to filter for peaks present in at least two replicates"

Rscript filter_multiinter.r

echo "Step 5: merge the resulting peaks using d -3 option"

bedtools merge -d 3 -i 2reps_multiinter.bed | uniq > Peak\ files/ythdf2_peaks_final.bed

echo "Final number of peaks:"

wc -l Peak\ files/ythdf2_peaks_final.bed

echo "Cleaning up intermediate files"

rm rep1_bygene_sorted.bed
rm rep2_bygene_sorted.bed
rm rep3_bygene_sorted.bed

rm rep1_bygene_merged.bed
rm rep2_bygene_merged.bed
rm rep3_bygene_merged.bed

rm allreps_multiinter.bed
rm 2reps_multiinter.bed