#!/bin/bash

echo "Step 0: combine all m6A peaks into one bed file (C_new)"

cat GSM1135032_C_new-1_thout_peaks.txt GSM1135033_C_new-2_thout_peaks.txt > m6A_combined.bed

echo ""
echo "Step 1: sort the combined bed file"

bedtools sort -i m6A_combined.bed > m6A_sorted.bed

echo ""
echo "Step 2: merge the bed files for each replicate using the -d 3 option"

bedtools merge -d 3 -i m6A_sorted.bed | uniq > m6A_merged-new.bed

echo ""
echo "Final number of peaks:"

wc -l m6A_merged-new.bed

echo ""
echo "Cleaning up intermediate files"

rm m6A_combined.bed
rm m6A_sorted.bed

echo ""
echo "Use external resource to convert coordinated to hg19 (UCSC Liftover)"

echo "https://genome.ucsc.edu/cgi-bin/hgLiftOver"

echo "Use options: human, original assembly hg18, new assembly hg19, default for remaining options."
echo "File naming conventions: m6A_hg19_{date}.bed:"