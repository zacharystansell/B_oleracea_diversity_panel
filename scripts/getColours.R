getColors <- getColours <- function(k)
{
  if(length(k) > 1) stop("getColours: Input has more than one value. Argument k must be a single numeric or integer.")
  if(!is.integer(k) && !is.numeric(k) ) stop("getColours: Input is not an integer. Argument k must be a single numeric or integer.")
  k <- as.integer(k)
  # standard colours
  col1 <- c("#2121D9","#9999FF","#DF0101","#04B404","#FFFB23","#FF9326","#A945FF","#0089B2","#B26314","#610B5E","#FE2E9A","#BFF217")
  # col1 <- c("#1D72F5","#DF0101","#77CE61", 
  #           "#FF9326","#A945FF","#0089B2",
  #           "#FDF060","#FFA6B2","#BFF217",
  #           "#60D5FD","#CC1577","#F2B950",
  #           "#7FB21D","#EC496F","#326397",
  #           "#B26314","#027368","#A4A4A4",
  #           "#610B5E")
  if(k <= 12) return(col1[1:k])
  if(k > 12) 
  {
    cr <- colorRampPalette(colors=c("#000040FF","#00004FFF","#000060FF","#000074FF","#000088FF","#00009DFF","#0000B2FF",
                                    "#0000C6FF","#000CD8FF","#0022E7FF","#0037F3FF","#004BFBFF","#005EFFFF","#0070FEFF",
                                    "#0081F8FF","#0091EEFF","#00A0E0FF","#00ADCFFF","#00BABCFF","#00C6A7FF","#01D092FF",
                                    "#02DA7EFF","#03E26AFF","#07E958FF","#0EF047FF","#1BF539FF","#31F92CFF","#54FC22FF",
                                    "#80FE1AFF","#ABFF13FF","#CEFF0EFF","#E4FE0AFF","#F1FB07FF","#F8F805FF","#FCF403FF",
                                    "#FDEE02FF","#FEE801FF","#FFE001FF","#FFD801FF","#FFCE00FF","#FFC300FF","#FFB800FF",
                                    "#FFAB00FF","#FF9D00FF","#FF8E00FF","#FF7E00FF","#FF6D00FF","#FF5B00FF","#FF4700FF",
                                    "#FF3300FF"),space="rgb")
    return(cr(k))
  }
}
