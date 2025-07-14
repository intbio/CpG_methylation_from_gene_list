#!/usr/bin/env bash
#— Скрипт «50 генов → финальная таблица»
#   вывод: Gene  chr:start-end  CpG_sites  mean_coverage
#   требуются: samtools ≥1.12, bedtools, mosdepth, modkit ≥0.
set -euo pipefail

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

zgrep -v '^#' mods_cpg.bed.tmp.gz \
| awk -v thr="$METH_COV_THRESH" '($11+0) >= thr' \
| bgzip > mods_cpg_filt.bed.gz
tabix -p bed mods_cpg_filt.bed.gz
