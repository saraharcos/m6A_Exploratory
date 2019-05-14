#!/bin/bash
echo ""
echo "Step 1: Intersect to find overlapping peaks from ythdf2 angle"

bedtools intersect -wa -a Peak\ files/ythdf2_peaks_final.bed -b Peak\ files/m6a_hg19_new_041619.bed | uniq > Overlap\ beds/ythdf2_venncenter.bed

wc -l Overlap\ beds/ythdf2_venncenter.bed

echo ""
echo "Step 2: Intersect to find overlapping peaks from m6a angle"

bedtools intersect -wa -a Peak\ files/m6a_hg19_new_041619.bed -b Peak\ files/ythdf2_peaks_final.bed | uniq > Overlap\ beds/m6a_venncenter.bed

wc -l Overlap\ beds/m6a_venncenter.bed

echo ""
echo "Step 3: Intersect to find exclusive peaks from ythdf2 angle"

bedtools intersect -v -a Peak\ files/ythdf2_peaks_final.bed -b Peak\ files/m6a_hg19_new_041619.bed | uniq > Overlap\ beds/ythdf2_vennexclusive.bed

wc -l Overlap\ beds/ythdf2_vennexclusive.bed

echo ""
echo "Step 4: Intersect to find exclusive peaks from m6a angle"

bedtools intersect -v -a Peak\ files/m6a_hg19_new_041619.bed -b Peak\ files/ythdf2_peaks_final.bed | uniq > Overlap\ beds/m6a_vennexclusive.bed

wc -l Overlap\ beds/m6a_vennexclusive.bed
echo ""