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
