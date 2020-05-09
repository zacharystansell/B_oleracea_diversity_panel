pop.names = c("Calabrese.F1","Calabrese.LR","Sprouting.Broccoli","Violet.Caul","Admixed")
pop.colors = c("#1b9e77","#7570b3","#e7298a","#d95f02",alpha("black",0.5))
write.csv(data.frame(pop.names,pop.colors),file="../DATA/populations.csv", row.name=FALSE)