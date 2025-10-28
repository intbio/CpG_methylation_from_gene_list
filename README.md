# CpG_methylation_from_gene_list
this script allows you to acquire information about number of CpG and their 
methylation in the promoters of listed genes

used libraries:
samtools                  1.22
bedtools                  2.31.1 
mosdepth                  0.3.10 
modkit                    1.3.0

to use this script you need to have:

1) gene_list.txt containing list of the genes it 1 row without spaces

2) GTF-annotation 

3) BAM-file with methylation information (for example from ONT dorado 
basecalling) + BAI index of this file (be sure to have it in the same
directory)

4) FASTA file of the reference genome + FAI + mmi (be sure to have it in the same
directory)

Usage: cpg_table.sh [options]

  -g  gene list file.txt                  []
  
  -p  promoter length, bp                 [500]
  
  -a  GTF-annotation                      []
  
  -b  BAM                                 [] 
  
  -r  reference FASTA                     []
  
  -t  threshold of methylation accuracy   [0.75]
  
  -c  threshold % meth-reads coverage (β) [50]
  
  -n  threads                             [8]
  
  -o  output (.tsv)                       [prom_CpG.tsv]
  
  -h  help

EXAMPLE OF USING THE SCRIPT: 
./cpg_table.sh -p 100 -a gencode.v44.annotation.gtf -b \
heK_calls_all.sorted.bam -r test/hg38.fa -o fasta_test.tsv -g top50_genes.txt
