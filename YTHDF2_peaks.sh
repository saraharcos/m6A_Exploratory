#!/bin/bash

echo "Read each replicate from the excel into R, then output bed files of peaks filtered for genes that appear in all 3 replicates only."
echo ""
Rscript DF2_parclip_peakstobed.R

echo "Concatenate replicate 2 and 3 files, then use bedtools sort | bedtools merge | uniq > ythdf2_peaks_final.bed"
cat Pre-processing\ beds/ythdf2_rep1.bed Pre-processing\ beds/ythdf2_rep2.bed Pre-processing\ beds/ythdf2_rep3.bed | bedtools sort | bedtools merge -s -c 1,4,5,6,7 -o count,distinct,mean,distinct,distinct | bedtools sort | uniq > Peak\ files/ythdf2_peaks_final.bed

echo "Use awk to select only peaks with count > 1"
echo ""

cat Peak\ files/ythdf2_peaks_final.bed | awk '{ if ($4 > 1) { print } }' Peak\ files/ythdf2_peaks_final.bed > Peak\ files/ythdf2_peaks_final2.bed

echo ""
echo "Final number of peaks:"

wc -l Peak\ files/ythdf2_peaks_final2.bed






# 
# bedtools sort -i Pre-processing\ beds/ythdf2_rep1_bygene.bed > rep1_bygene_sorted.bed
# bedtools sort -i Pre-processing\ beds/ythdf2_rep2_bygene.bed > rep2_bygene_sorted.bed
# bedtools sort -i Pre-processing\ beds/ythdf2_rep3_bygene.bed > rep3_bygene_sorted.bed
# 
# echo "Step 2: merge the bed files for each replicate"
# 
# #bedtools merge -i rep1_bygene_sorted.bed | uniq > rep1_bygene_merged.bed
# #bedtools merge -i rep2_bygene_sorted.bed | uniq > rep2_bygene_merged.bed
# #bedtools merge -i rep3_bygene_sorted.bed | uniq > rep3_bygene_merged.bed
# 
# echo "Step 3: use intersect commands to calculate peak intersections"
# 
# bedtools intersect -a rep1_bygene_sorted.bed -b rep2_bygene_sorted.bed rep3_bygene_sorted.bed -u | uniq > rep1_intersected.bed
# bedtools intersect -a rep2_bygene_sorted.bed -b rep1_bygene_sorted.bed rep3_bygene_sorted.bed -u | uniq > rep2_intersected.bed
# bedtools intersect -a rep3_bygene_sorted.bed -b rep1_bygene_sorted.bed rep2_bygene_sorted.bed -u | uniq > rep3_intersected.bed
# 
# 
# 
# echo "Step 4: Concatenate files and sort"
# 
# cat *intersected.bed | bedtools sort > allreps_intersected.bed
# 
# echo "Step 5: merge the resulting peaks option"
# 
# #bedtools merge -i allreps_intersected.bed | uniq > Peak\ files/ythdf2_peaks_final.bed
# 
# echo "Final number of peaks:"
# 
# wc -l allreps_intersected.bed
# 
# bedtools merge -i allreps_intersected.bed | uniq > Peak\ files/ythdf2_peaks_final.bed
# 
# wc -l Peak\ files/ythdf2_peaks_final.bed
# 
# echo "Cleaning up intermediate files"
# 
# rm rep1_bygene_sorted.bed
# rm rep2_bygene_sorted.bed
# rm rep3_bygene_sorted.bed
# 
# rm rep1_bygene_merged.bed
# rm rep2_bygene_merged.bed
# rm rep3_bygene_merged.bed
# 
# rm rep1_intersected.bed
# rm rep2_intersected.bed
# rm rep3_intersected.bed
# 
# rm allreps_intersected.bed