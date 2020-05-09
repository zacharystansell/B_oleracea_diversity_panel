# Cleans up and assigns chromosomes from TASSEL Diversity output for R
assignChromosomes <- function(x) {
  find_peaks <- function (x, m = 3) {
    shape <- diff(sign(diff(x, na.pad = FALSE)))
    pks <- sapply(
      which(shape < 0),
      FUN = function(i) {
        z <- i - m + 1
        z <- ifelse(z > 0, z, 1)
        w <- i + m + 1
        w <- ifelse(w < length(x), w, length(x))
        if (all(x[c(z:i, (i + 2):w)] <= x[i + 1]))
          return(i + 1)
        else
          return(numeric(0))
      }
    )
    pks <- unlist(pks)
    pks
  }

  #get rid of commas
  x[, 3] <- as.numeric(gsub(",", "", x[, 3]))
  x[, 4] <- as.numeric(gsub(",", "", x[, 4]))
  breaks <-
    c(0, as.numeric(rownames(x)[find_peaks(x[, 3])]), length(rownames(x)))
  CHR <- NULL
  for (i in 2:10) {
    CHR[[i - 1]] <- rep(i - 1, breaks[i] - cumsum(breaks[i - 1]))
  }
  CHR <- unlist(CHR)
  x[, 2] <- CHR
  x[, 2]  <- dplyr::recode(
    (x[, 2]),
    "1" = "chr1",
    "2" = "chr2",
    "3" = "chr3",
    "4" = "chr4",
    "5" = "chr5",
    "6" = "chr6",
    "7" = "chr7",
    "8" = "chr8",
    "9" = "chr9"
  )

  #Chop off overlapping CHR1-CHR2 regions
  x <- x[x[,3] < x[,4],]

  return(x)
}



