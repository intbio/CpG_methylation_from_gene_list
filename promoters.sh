                     # длина промотора, bp

awk -v P=$PROM 'BEGIN{OFS="\t"}
{
    if ($5 == "+") {
        s = ($2-P<0)?0:$2-P         # upstream
        e = $2                      # TSS
    } else {                        # минус-цепь
        s = $3                      # TSS
        e = $3+P                    # downstream в координатах hg38
    }
    # BED требует start<end
    if (s<e) print $1,s,e,$4"_prom"
    else     print $1,e,s,$4"_prom"
}' tmp.bed > prom_tmp.bed

