# Analysis pipeline. Contains choices about which samples are included. 
pipeline <- read.csv("../DATA/pipeline.csv")

#Passport data for landraces and commercial germplasm
accessions <- read.csv("../DATA/GERMPLASM/italian_germplasm.csv") %>% dplyr::select(geno,Lat,	Long)
commercial <- read.csv("../DATA/GERMPLASM/GBS_germplasm.csv") %>% dplyr::select(geno,	Name,	SOURCE,	PI,	release,	maturity)

# Raw phenotypic data
pheno <- read.csv("../DATA/PHENOTYPE/pheno_final.csv")

# Population Structure and PCA Data
Q <- read.csv("../OUTPUT/DIVERSITY/STRUCTURE/Q.csv")
PCA <- read.delim("../OUTPUT/DIVERSITY/PCA/PCA1.txt",sep = "\t", skip = 2)

# Define traits evaluated...
traits <- read.csv("../DATA/PHENOTYPE/traits.csv", row.names = NULL, stringsAsFactors = FALSE)$Code

# Recode names
oldNames <- c("short.name", 
              "cross.type",
              "groupQ",
              "SOURCE",
              "release")

newNames <- c("Name",
              "Type",
              "Group",
              "Source",
              "Release.Collection")

# non averaged data for anova.. 
#Trial 0 = GBS samples, trial 1 = planting 1, trial 2 = planting 2. 
m <- pheno  %>% 
  dplyr::filter(trial %in% c(1,2)) %>%  
  dplyr::select(geno,all_of(traits)) %>% 
  group_by(geno)

m <- merge(pipeline, m, by="geno", all.x=TRUE)
m <- merge(m, commercial,  by="geno", all.x=TRUE)
m <- merge( m, accessions, by="geno", all.x=TRUE)
m <- merge(m, Q,by.x="short.name", by.y="gbs", all.x=TRUE)
m <- merge(m, PCA, by.x="gbs",by.y="Taxa", all.x=TRUE)
m <- m %>%  filter(N109 %in% "y")  %>%  setnames(old=oldNames, new=newNames, skip_absent=TRUE)
m[m == "NaN"] <- NA

PSPraw <- m
write.csv(PSPraw, "../DATA/PHENOTYPE/PSPraw.csv")

# Summarized results
m <- pheno  %>% 
  filter(trial %in% c(1,2)) %>%  
  dplyr::select(geno, traits) %>% 
  group_by(geno)  %>%  
  summarise_at(traits, mean, na.rm = TRUE)
m <- merge(pipeline, m, by="geno", all.x=TRUE) 
m <- merge(m, commercial,  by="geno", all.x=TRUE)
m <- merge(m, accessions, by="geno", all.x=TRUE)
m <- merge(m, Q,by.x="short.name", by.y="gbs", all.x=TRUE)
m <- merge(m, PCA, by.x="gbs",by.y="Taxa", all.x=TRUE)
m <- m %>% filter(N109 %in% "y") 
m[m == "NaN"] <- NA

PSP <- m
write.csv(PSP, "../DATA/PHENOTYPE/PSP.csv")
#Make txt files of gbs names of each subpopulation..
subpops <- levels(PSP$subpop)
for (i in subpops) {
  Calabrese.F1 <-
    write.table(
      file = paste("../DATA/GBS/DATASETS/FILTERS/",gsub("\\.", "_", i), ".txt", sep = ""),
      PSP$gbs[PSP$subpop == i], quote=FALSE,row.names = FALSE, col.names=FALSE
    )
}




#Make LaTeX tables of data, by various geno, crosstype, and population structure (Q)
# make germplasm table

germplasm <- PSP[,c("short.name","subpop", "SOURCE","Lat","Long")]
germplasm$location <- paste(round(germplasm$Lat,1), " x ",round(germplasm$Long,1), sep="")
germplasm$location <- gsub("NA x NA" , "-", germplasm$location)

germplasm <- germplasm[,c("short.name","subpop", "SOURCE","location")]
colnames(germplasm) <- c("Accession", "Subpopulation","Source", "Collection Location")


print.xtable(
  xtable(
    germplasm,
    caption = "Accessions included in analysis, by subpopulation determined in structure analysis, seed source, and accession collection location (N$^{\\circ}$ x W$^{\\circ}$)",
    type = "latex",
    label = "tab:germplasm",
    digits = 1,
    
  ),
  include.rownames = FALSE ,
  NA.string = "NA",
  scalebox = 0.5,
  file = "../DRAFT/SUBMISSION/SciReports/TABLES/germplasm.tex"
)



# nean trait values
phenotypes  <- PSP %>%
  dplyr::filter(good.pheno %in% "y") %>%
  group_by(geno) %>%
  summarise_at(traits, mean, na.rm = TRUE)

print.xtable(
  xtable(
    phenotypes,
    caption = "Mean trait values by accession",
    type = "latex",
    label = "geno",
    digits = 1,
    
  ),
  include.rownames = FALSE ,
  NA.string = "NA",
  scalebox = 0.5,
  file = "../DRAFT/SUBMISSION/SciReports/SUPPLEMENTARY/TABLES/phenotypes.tex"
)


header.true <- function(df) {
  names(df) <- as.character(unlist(df[1,]))
  df[-1,]
}


subpop  <- PSP %>% dplyr::filter(good.geno == "y") %>%
  group_by(subpop) %>%
  summarise_at(traits, mean, na.rm = TRUE) %>%
  t()  %>% data.frame() %>%  header.true()
write.csv(subpop,
          "../OUTPUT/PHENOTYPE/SUMMARY_STATS/subpop",
          row.names = TRUE)
subpop <-
  read.csv("../OUTPUT/PHENOTYPE/SUMMARY_STATS/subpop", row.names = 1)

#print(, file = "../OUTPUT/PHENOTYPE/SUMMARY_STATS/subpop.tex")
print.xtable(xtable(
  subpop,
  caption = "Mean trait values by (K = 4) subpopulation",
  type = "latex",
  label = "subpop" ,
  digits = 1
), scalebox = 0.5,
file = "../DRAFT/SUBMISSION/SciReports/SUPPLEMENTARY/TABLES/subpop.tex")

# make trait table

traits <- read.csv("../DATA/PHENOTYPE/traits.csv", row.names = NULL, stringsAsFactors = FALSE)[,c(2,3,5)]

print.xtable(
  xtable(
    traits,
    caption = "Traits evaluated, by code, trait class, and description.",
    type = "latex",
    label = "tab:traits",
    digits = 1,
    
  ),
  include.rownames = FALSE ,
  NA.string = "NA",
  scalebox = 0.75,
  file = "../DRAFT/SUBMISSION/SciReports/TABLES/traits.tex"
)








# Make plink family files

write_delim(cbind(-9,PSP[,c("gbs","subpop","gbs")]), "../DATA/GBS/DATASETS/BOL/PLINK/family.txt", delim="\t", col_names=FALSE )




rm(list=ls())
