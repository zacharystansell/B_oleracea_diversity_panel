poscum <- function(chr, pos){
  posmin <- tapply(pos,chr, min);
  posmax <- tapply(pos,chr, max);
  posshift <- head(c(0,cumsum(posmax)),-1);
  names(posshift) <- levels(chr)
  genpos <- pos + posshift[chr];
  getGenPos <-function(chr, pos) {
    p<-posshift[as.character(chr)]+pos
    return(p)
  }
  out <- getGenPos(chr,pos)
  #return(out)
}