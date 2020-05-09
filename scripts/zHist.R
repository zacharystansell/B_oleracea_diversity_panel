
# Histogram of Z score function
zHist <- function(df, stat, breaks=1000, col="purple",Z=Z, ...){
  breaks = breaks
  hh <- max(hist(df[,stat],breaks=breaks, plot=FALSE)$counts)
  hist( df[,stat], breaks=breaks,ylab="Window No", col=col ,xlab="Z-score", main=deparse(substitute(df)), border=col)
  abline(v= Z, lty=2, lwd=2, col="red")
  text(x = 0.75*max(df[,stat]), y= 0.75*hh,expression(paste(Z[F[st]])), font=2, cex = 1.5)
  text(x = 0.75*max(df[,stat]), y= 0.65*hh,expression(paste("(", mu," = 0; ", alpha," = 1)")),cex = 1.25)
  text(x = 0.40*max(df[,stat]), y= 0.55*hh,"Z = +2.33", cex = 1.0)
  text(x = 0.40*max(df[,stat]), y= 0.45*hh,expression(paste(alpha," = 0.01")), cex = 1.0)
  box()
  
}