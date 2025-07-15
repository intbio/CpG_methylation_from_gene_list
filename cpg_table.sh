#!/usr/bin/env bash
set -euo pipefail
gene_list=""
annotation=""
BAM=""
REF=""
PROM=500
THRESH=0.75
METH_COV_THRESH=50
THREADS=8
OUT="prom_CpG.tsv"

usage() {
cat <<EOF
Usage: $(basename "$0") [options]

  -g  gene list file.txt                  [$gene_list]
  -p  promoter length, bp                 [$PROM]
  -a  GTF-annotation                      [$annotation]
  -b  BAM	                          [$BAM] 
  -r  reference FASTA                     [$REF]
  -t  threshold of methylation accuracy   [$THRESH]
  -c  threshold % meth-reads coverage (β) [$METH_COV_THRESH]
  -n  threads                             [$THREADS]
  -o  output (.tsv)                       [$OUT]
  -h  help

be sure you have modkit, samtools, bedtools, mosdepth
EOF
exit 1
}

while getopts ":g:p:a:b:r:t:c:n:o:h" opt; do
  case $opt in
    g) gene_list=$OPTARG ;;
    p) PROM=$OPTARG ;;
    a) annotation=$OPTARG ;;
    b) BAM=$OPTARG ;;
    r) REF=$OPTARG ;;
    t) THRESH=$OPTARG ;;
    c) METH_COV_THRESH=$OPTARG ;;
    n) THREADS=$OPTARG ;;
    o) OUT=$OPTARG ;;
    h|\?) usage ;;
  esac
done
if [[ -z "$gene_list" || -z "$PROM" || -z "$annotation" || -z "$BAM" || -z "$REF" ]]; then
  echo "Error: Missing required arguments."
  usage
fi
export gene_list PROM annotation BAM REF THRESH METH_COV_THRESH THREADS OUT
echo "you entered $gene_list $PROM $annotation $BAM $REF $THRESH $METH_COV_THRESH $THREADS"
bash genes_annot.sh 
bash promoters.sh 
if [ ! -f "mods_cpg_filt.bed.gz" ]; then
    # Блок кода, который выполняется ТОЛЬКО если файл отсутствует
    echo "Файл не найден, выполняем действия"
    bash pileup.sh
fi
bash stats.sh
rm -f *tmp*
