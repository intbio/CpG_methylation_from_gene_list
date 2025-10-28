## genes50.bed  →  chr  start  end  gene  strand
awk '
  BEGIN {OFS="\t"}
  $3=="gene" {
      match($0,/gene_name "([^"]+)"/,a)
      gene=a[1]
      print $1,$4-1,$5,gene,$7
  }' $annotation \
| grep -Fwf "$gene_list"  > tmp.bed
