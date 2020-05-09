
plotGWAS <- function(df, filename="../OUTPUT/GWAS/temp.png", res=150) {
  
  temp <- df %>% 
    # dplyr::rename(Chr = Locus) %>% 
    dplyr::select(Marker, Chr , Pos, p, Trait)
  colnames(temp) <- c("SNP", "CHR", "BP", "P", "trait")
  temp$CHR <- as.numeric(substr(as.character(temp$CHR), 2, 2))
  temp <- na.omit(temp)
  traits  <- levels(temp$trait)
  png(filename = filename, res=res, units="in", height = 15, width = 20)
  par(mfcol = c(5, 5), mar = c(2, 2, 1, 1))
  for (i in traits) {
    mat <- temp[temp$trait == i, ]
    manhattan(mat, main = paste(i), col = viridis(9))
  }
  dev.off()
}