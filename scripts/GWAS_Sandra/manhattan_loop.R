#for i in $(cat trait_list.txt); do Rscript --vanilla manhattan_loop.R "mlm_"$i".csv" "man_"$i".png" "qq_"$i".png"; done



args<-commandArgs(TRUE)
library(qqman)
filein<-args[1]
fileout1<-args[2]
fileout2<-args[3]
d<-read.csv(filein, header=T, stringsAsFactors=F)
use<-d[complete.cases(d),]

png(fileout1)
manhattan(use)
dev.off()

png(fileout2)
qq(use$P)
dev.off()
