#!/usr/bin/env bash
set -euo pipefail
gene_list=""
annotation=""
BAM=""
REF=""
PROM=500
THRESH=75
METH_COV_THRESH=50
THREADS=8


usage() {
cat <<EOF
Usage: $(basename "$0") [options]

  -g  gene list file.txt                  [$gene_list]
  -p  promoter length, bp                 [$PROM]
  -a  GTF-annotation                      [$annotation]
  -b  BAM 
  -r  reference FASTA                     [$REF]
  -t  threshold of methylation accuracy   [$THRESH]
  -c  threshold % meth-reads coverage (β) [$METH_COV_THRESH]
  -n  threads                             [$THREADS]
  -h  help
EOF
exit 1
}

while getopts ":g:p:a:b:r:t:c:n:h" opt; do
  case $opt in
    g) gene_list=$OPTARG ;;
    p) PROM=$OPTARG ;;
    a) annotation=$OPTARG ;;
    b) BAM=$OPTARG ;;
    r) REF=$OPTARG ;;
    t) THRESH=$OPTARG ;;
    c) METH_COV_THRESH=$OPTARG ;;
    n) THREADS=$OPTARG ;;
    h|\?) usage ;;
  esac
done
if [[ -z "$gene_list" || -z "$PROM" || -z "$annotation" || -z "$BAM" || -z "$REF" ]]; then
  echo "Error: Missing required arguments."
  usage
fi
export gene_list PROM annotation BAM REF THRESH METH_COV_THRESH THREADS
echo "you entered $gene_list $PROM $annotation $BAM $REF $THRESH $METH_COV_THRESH $THREADS"
bash genes_annot.sh 
bash promoters.sh 
bash pileup.sh
bash stats.sh
rm -f *tmp*
