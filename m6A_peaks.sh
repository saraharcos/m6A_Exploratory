#!/bin/bash

echo "Concatenate two replicate files, then use bedtools sort | bedtools merge | uniq > m6A_peaks_hg18.bed"
cat Source\ files/GSM* | bedtools sort | bedtools merge | uniq > Peak\ files/m6A_peaks_hg18.bed

# echo ""
# echo "Step 1: sort the combined bed file"
# 
# bedtools sort -i m6A_combined.bed > m6A_sorted.bed
# 
# echo ""
# echo "Step 2: merge the bed files for each replicate using the -d 3 option"
# 
# bedtools merge -d 3 -i m6A_sorted.bed | uniq > m6A_merged-new.bed
# 
# echo ""
# echo "Final number of peaks:"
# 
# wc -l m6A_merged-new.bed
# 
# echo ""
# echo "Cleaning up intermediate files"
# 
# rm m6A_combined.bed
# rm m6A_sorted.bed
# 
# echo ""
# echo "Use external resource to convert coordinated to hg19 (UCSC Liftover)"
# 
# echo "https://genome.ucsc.edu/cgi-bin/hgLiftOver"
# 
# echo "Use options: human, original assembly hg18, new assembly hg19, default for remaining options."
# echo "File naming conventions: m6A_hg19_{date}.bed:"
# 
# echo ""
# echo "Alternate pathway: intersect the two replicates, then combine for final peaks"
# 
# bedtools sort -i Source\ files/GSM1135032_C_new-1_thout_peaks.txt > m6A_rep1_sorted.bed
# bedtools sort -i Source\ files/GSM1135033_C_new-2_thout_peaks.txt > m6A_rep2_sorted.bed
# 
# bedtools intersect -a m6A_rep1_sorted.bed -b m6A_rep2_sorted.bed -u | uniq > m6A_rep1_intersected.bed
# bedtools intersect -a m6A_rep2_sorted.bed -b m6A_rep1_sorted.bed -u | uniq > m6A_rep2_intersected.bed
# 
# cat m6A*intersected.bed | bedtools sort | bedtools merge | uniq > m6A_new_final.bed
# 
# wc -l m6A_new_final.bed
# 
# cat m6A*intersected.bed | uniq > tester.bed
# 
# wc -l tester.bed
# 
# echo "Cleaning up intermediate files"
# 
# rm m6A_rep1_sorted.bed
# rm m6A_rep2_sorted.bed
# rm m6A_rep1_intersected.bed
# rm m6A_rep2_intersected.bed
# 
# 
# 
