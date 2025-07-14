echo "enter gene_list, promoter_size, annotation, BAM_file, reference_genome, methylation_define_th(%), methylation_coverage_th, threads"
read gene_list PROM annotation BAM REF THRESH METH_COV_THRESH THREADS
echo "you entered $gene_list $promoter_size $annotation $BAM $REF $THRESH $METH_COV_THRESH $THREADS"
#bash genes_annot.sh 
#bash promoters.sh 
#bash pileup.sh
#bash stats.sh
#rm -f *tmp*
