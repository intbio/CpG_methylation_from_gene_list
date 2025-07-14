#!/usr/bin/env bash
#— Скрипт «50 генов → финальная таблица»
#   вывод: Gene  chr:start-end  CpG_sites  mean_coverage
#   требуются: samtools ≥1.12, bedtools, mosdepth, modkit ≥0.4

set -euo pipefail
THREADS=16

BAM="heK_calls_all.sorted.bam"          # ваш выровненный файл ONT
GENES="prom_top50.bed"        # chr  start  end  GeneName   (0-based BED)
REF="hg38.fa"              # FASTA hg38
PROB=0.75                  # порог уверенности метила (0-1)
THREADS=4                 # параллель
THRESH=0.75                # отсечка «уверенности» метила
METH_COV_THRESH=100
###############################################################################
# 1) Оставляем ТОЛЬКО «уверенные» вызовы 5mC в контексте CpG
###############################################################################
modkit pileup \
       --cpg --combine-strands \
       --filter-threshold "$THRESH" \
       -t "$THREADS" \
       -r "$REF" \
       "$BAM" mods_cpg.bed.tmp
bgzip -@ "$THREADS" mods_cpg.bed.tmp
tabix -p bed mods_cpg.bed.tmp.gz     # индекс для быстрых запросов

zcat mods_cpg.bed.tmp.gz \
| awk -v thr="$METH_COV_THRESH" 'BEGIN{OFS="\t"}
     /^#/ {print; next}                 # оставляем строки-шапки
     {
       m   = $7 + 0;                    # 7-я колонка = count_m
       u   = $8 + 0;                    # 8-я колонка = count_u
       tot = m + u;
       if (tot == 0) next;              # на всякий случай
       perc = (m / tot) * 100;
       if (perc >= thr) print;          # сайт проходит порог
     }' \
| bgzip > mods_cpg_filt.bed.tmp.gz
tabix -p bed mods_cpg_filt.bed.tmp.gz
