#!/bin/bash

echo "Step 0: read each replicate from the excel into R, then output bed files of peaks filtered for genes that appear in all 3 replicates only."

Rscript DF2_parclip_peakstobed.R

echo "Step 1: sort the bed files for each replicate"

bedtools sort -i Pre-processing\ beds/ythdf2_rep1_bygene.bed > rep1_bygene_sorted.bed
bedtools sort -i Pre-processing\ beds/ythdf2_rep2_bygene.bed > rep2_bygene_sorted.bed
bedtools sort -i Pre-processing\ beds/ythdf2_rep3_bygene.bed > rep3_bygene_sorted.bed

echo "Step 2: merge the bed files for each replicate"

#bedtools merge -i rep1_bygene_sorted.bed | uniq > rep1_bygene_merged.bed
#bedtools merge -i rep2_bygene_sorted.bed | uniq > rep2_bygene_merged.bed
#bedtools merge -i rep3_bygene_sorted.bed | uniq > rep3_bygene_merged.bed

echo "Step 3: use intersect commands to calculate peak intersections"

bedtools intersect -a rep1_bygene_sorted.bed -b rep2_bygene_sorted.bed rep3_bygene_sorted.bed -u | uniq > rep1_intersected.bed
bedtools intersect -a rep2_bygene_sorted.bed -b rep1_bygene_sorted.bed rep3_bygene_sorted.bed -u | uniq > rep2_intersected.bed
bedtools intersect -a rep3_bygene_sorted.bed -b rep1_bygene_sorted.bed rep2_bygene_sorted.bed -u | uniq > rep3_intersected.bed



echo "Step 4: Concatenate files and sort"

cat *intersected.bed | bedtools sort > allreps_intersected.bed

echo "Step 5: merge the resulting peaks option"

#bedtools merge -i allreps_intersected.bed | uniq > Peak\ files/ythdf2_peaks_final.bed

echo "Final number of peaks:"

wc -l allreps_intersected.bed

bedtools merge -i allreps_intersected.bed | uniq > Peak\ files/ythdf2_peaks_final.bed

wc -l Peak\ files/ythdf2_peaks_final.bed

echo "Cleaning up intermediate files"

rm rep1_bygene_sorted.bed
rm rep2_bygene_sorted.bed
rm rep3_bygene_sorted.bed

rm rep1_bygene_merged.bed
rm rep2_bygene_merged.bed
rm rep3_bygene_merged.bed

rm rep1_intersected.bed
rm rep2_intersected.bed
rm rep3_intersected.bed

rm allreps_intersected.bed