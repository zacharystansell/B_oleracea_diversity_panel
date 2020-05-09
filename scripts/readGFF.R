gff <- read.gff("../DATA/GBS/REFERENCE_GENOMES/BOL/Brassica_oleracea.BOL.45.gff3")

gff <- gff[gff$type == "mRNA", ]


chromosomes <- list("C1" ,
                    "C2" ,
                    "C3" ,
                    "C4" ,
                    "C5" ,
                    "C6" ,
                    "C7" ,
                    "C8" ,
                    "C9")

gff <- drop.levels(gff[gff$seqid %in% chromosomes, ])

gff <- data.frame(gff$seqid, gff$start, gff$end, gff$attributes)
colnames(gff) <- c("chr", "start", "end", "attr")
gff$chr <- as.character(gff$chr)
gff$chr <- paste("chr", substr(gff$chr, 2, 2), sep = "")
is.valid.region(gff)