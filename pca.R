
# Population clustering using PCA data and KNN

args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  stop("There is no input filename\n", call.=FALSE)
}

cmd = getwd()

# read two input files
# 1. eigen vector from PCA
# 2. Ancestry race from 1 KG
filename = paste(args[1],"eigenvec",sep='.')
PCA <- read.csv(filename, header = FALSE, sep = " ", stringsAsFactors = FALSE)
PCA[PCA[,1]=="FBC"|PCA[,1]=="M",1] = paste(PCA[PCA[,1]=="FBC"|PCA[,1]=="M",1],PCA[PCA[,1]=="FBC"|PCA[,1]=="M",2],sep='_')
colnames(PCA) = c("sample","IID","PC1","PC2","PC3","PC4","PC5","PC6","PC7","PC8","PC9","PC10","PC11","PC12","PC13","PC14","PC15","PC16","PC17","PC18","PC19","PC20")

setwd("/home/xf2193/project/PCA")
# sample pop     Race gender
kgp <- read.csv("AncestryPCA.master.panel", header = TRUE, sep = "\t", stringsAsFactors = FALSE)[,1:4]
kgp$pop = kgp$super_pop
kgp[kgp$pop=="EAS",2] = "AFR"

colnames(kgp)[3] = "Race"
kgp[kgp$Race=="AFR",3] = "African"
kgp[kgp$Race=="AJ",3] = "Ashkenazi Jewish"
kgp[kgp$Race=="AMR",3] = "Native American"
kgp[kgp$Race=="DOMI",3] = "Dominican"
kgp[kgp$Race=="EAS",3] = "East Asian"
kgp[kgp$Race=="EUR",3] = "European"
kgp[kgp$Race=="SAS",3] = "South Asian"


# KNN clustering
library(class)
source("multiplot.R")

Label <- merge(PCA,kgp,by="sample",all=TRUE,sort=FALSE)
train = Label[(Label[,1] %in% kgp$sample),]
test = Label[!(Label[,1] %in% kgp$sample),]
# train = Label[(Label[,1] %in% kgp$sample),1:7]
# test = Label[!(Label[,1] %in% kgp$sample),1:7]
cl = Label[(Label[,1] %in% kgp$sample),24]
  
race <- knn(train[,3:22], test[,3:22], cl, k = 5, l = 2, prob = TRUE, use.all = TRUE)
# race <- knn(train[,3:7], test[,3:7], cl, k = 5, l = 2, prob = TRUE, use.all = TRUE)
b <- data.frame(race)
result <- cbind(test,b)
EUR = result[result$race=="European",1]


# write the results
setwd(cmd)

filename = paste(args[1],"EUR.fam",sep='_')
write.table(EUR,filename, row.names = FALSE, col.names = FALSE, quote = FALSE)
filename = paste(args[1],"PCA_race.csv",sep='_')
write.table(result,filename,row.names=FALSE,sep=',')

library(ggplot2)


# generate scatter plot
ref = merge(PCA,kgp,all.y=TRUE,by="sample",sort=FALSE)
ref["x"] = NA
ref["y"] = NA
results = cbind(test,b)

filename = paste(args[1],"PCA",sep='_')
for (i in 1:3) {
  
  p1 = ggplot(ref, aes(x=ref[,(2*i+1)], y=ref[,(2*i+2)], color=Race)) +
    geom_point() +
    xlab(paste("PC",(2*i-1),sep="")) +
    ylab(paste("PC",(2*i),sep="")) +
    ggtitle("PCA in 1000Genome") +
    theme(axis.title=element_text(size=14), axis.text = element_text(size = 14), plot.title = element_text(hjust = 0.5, face="bold"), legend.title = element_text(size=13), legend.text = element_text(size=13))
  
  p2 = ggplot(results, aes(x=results[,(2*i+1)], y=results[,(2*i+2)], color=race)) +
    geom_point() + 
    xlab(paste("PC",(2*i-1),sep="")) +
    ylab(paste("PC",(2*i),sep="")) +
    ggtitle("PCA in PCM cohort") +
    theme(axis.title=element_text(size=14), axis.text = element_text(size = 14), plot.title = element_text(hjust = 0.5, face="bold"), legend.title = element_text(size=13), legend.text = element_text(size=13))
  
  fileout = paste(filename,i,sep='')
  png(paste(fileout,'png',sep='.'))
  multiplot(p1, p2, cols=2)
  dev.off()
}
