library(mrMLM)

mrMLM(fileGen="sub123.hmp.txt",filePhe="sub123_aac4x.csv",fileKin="sub123_kinship.txt",filePS=NULL,Genformat="Hmp",method=c("mrMLM","FASTmrMLM","FASTmrEMMA","pLARmEB","pKWmEB","ISISEM-BLASSO"),Likelihood="REML",trait=1:6,SearchRadius=20,CriLOD=3,SelectVariable=50,Bootstrap=FALSE,DrawPlot=TRUE,Plotformat ="png",Resolution="Low",dir="/media/biolinuxuser/DataDrive1/work/Pat/camarus_reseq/prePanGenome/CucCAP2019/mrMLM")
