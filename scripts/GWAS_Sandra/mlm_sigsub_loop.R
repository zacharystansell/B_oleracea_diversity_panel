#for i in $(cat trait_list.txt); do Rscript --vanilla mlm_sigsub_loop.R "mlm_"$i".csv" "sig_"$i".csv"; done

args<-commandArgs(TRUE)
filein<-args[1]
fileout<-args[2]
d<-read.csv(filein, header=T, stringsAsFactors=F)
d$fdr<-p.adjust(d$P, method="BH")
sub<-subset(d, d$fdr<0.1)
print(filein)
print(dim(subset(d, d$fdr<0.1)))
print(dim(subset(d, d$fdr<0.05)))
print(dim(subset(d, d$fdr<0.01)))
print(min(d$fdr, na.rm=T))
use<-d[complete.cases(d),]
print(head(use[order(use$P),]))
write.csv(sub, row.names=F, fileout)
