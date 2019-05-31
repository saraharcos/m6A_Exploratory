#!/bin/bash
echo ""
echo "Step 1: Intersect to find overlapping peaks from ythdf2 angle"

bedtools intersect -wa -a Peak\ files/ythdf2_peaks_final2.bed -b Peak\ files/m6a_peaks_hg19.bed | uniq > Overlap\ beds/ythdf2_venncenter.bed

wc -l Overlap\ beds/ythdf2_venncenter.bed

echo ""
echo "Step 2: Intersect to find overlapping peaks from m6a angle"

bedtools intersect -wa -a Peak\ files/m6a_peaks_hg19.bed -b Peak\ files/ythdf2_peaks_final2.bed | uniq > Overlap\ beds/m6a_venncenter.bed

wc -l Overlap\ beds/m6a_venncenter.bed

echo ""
echo "Step 3: Intersect to find exclusive peaks from ythdf2 angle"

bedtools intersect -v -a Peak\ files/ythdf2_peaks_final2.bed -b Peak\ files/m6a_peaks_hg19.bed | uniq > Overlap\ beds/ythdf2_vennexclusive.bed

wc -l Overlap\ beds/ythdf2_vennexclusive.bed

echo ""
echo "Step 4: Intersect to find exclusive peaks from m6a angle"

bedtools intersect -v -a Peak\ files/m6a_peaks_hg19.bed -b Peak\ files/ythdf2_peaks_final2.bed | uniq > Overlap\ beds/m6a_vennexclusive.bed

wc -l Overlap\ beds/m6a_vennexclusive.bed
echo ""

echo "Step 5: Select top 1000 peaks from each ythdf2 dataset for MEME analysis and select first 3 columns for all"
echo ""

sort -k6nr Overlap\ beds/ythdf2_venncenter.bed | head -1000 > Overlap\ beds/ythdf2_venncenter_top1000.bed

sort -k6nr Overlap\ beds/ythdf2_vennexclusive.bed | head -1000 > Overlap\ beds/ythdf2_vennexclusive_top1000.bed

sort -k6nr Peak\ files/ythdf2_peaks_final2.bed | head -1000 > Peak\ files/ythdf2_peaks_final2_top1000.bed

cut -f 1,2,3 Overlap\ beds/ythdf2_venncenter_top1000.bed > Overlap\ beds/ythdf2_venncenter_MEME1000.bed

cut -f 1,2,3 Overlap\ beds/ythdf2_vennexclusive_top1000.bed > Overlap\ beds/ythdf2_vennexclusive_MEME1000.bed

cut -f 1,2,3 Peak\ files/ythdf2_peaks_final2_top1000.bed > Peak\ files/ythdf2_peaks_final2_MEME1000.bed

cut -f 1,2,3 Overlap\ beds/ythdf2_venncenter.bed > Overlap\ beds/ythdf2_venncenter_MEME.bed

cut -f 1,2,3 Overlap\ beds/ythdf2_vennexclusive.bed > Overlap\ beds/ythdf2_vennexclusive_MEME.bed

cut -f 1,2,3 Peak\ files/ythdf2_peaks_final2.bed > Peak\ files/ythdf2_peaks_final2_MEME.bed


echo "Step 6: Select gene name column for input to GO analysis"
echo ""

cut -f 5 Overlap\ beds/ythdf2_venncenter.bed | uniq > Overlap\ beds/ythdf2_venncenter_genenames.bed

cut -f 5 Overlap\ beds/ythdf2_vennexclusive.bed | uniq > Overlap\ beds/ythdf2_vennexclusive_genenames.bed

cut -f 5 Peak\ files/ythdf2_peaks_final2.bed | uniq > Peak\ files/ythdf2_peaks_final2_genenames.bed









