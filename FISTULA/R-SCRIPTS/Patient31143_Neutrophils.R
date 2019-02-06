# Read the gene expression data set
Neutrophil <- read.csv(file="Neutrophil.csv",head=TRUE,sep=",")
p <- dim(Neutrophil);
Gene <- Neutrophil[1:1];
Data <- Neutrophil[2:(p[2])];
n <- dim(Data);
m <- ((n[2])/2);
head(Neutrophil)

Baseline <- Data$X31143.B; #to change with the patient code
Week2 <- Data$X31143.2W; #to change with the patient code
Patient1 <- data.frame(Gene,Baseline,Week2)
#head(Patient1)
View(Patient1)

# Calculate the average fold change for each gene from baseline to 2-weeks after fistula
log2FoldChange <- (Week2 - Baseline);

# Calculate the p-value of the t-test between baseline and 2-weeks after fistula
Pvalue <- apply(Data, 1, function(Data) {
  t.test(x = Data[1:m], y = Data[(m+1):(n[2])])$p.value})

# Save data
Results = cbind(Gene, log2FoldChange);
Results = cbind(Results, pvalue = Pvalue);
write.csv(Results, file = "Patient31143_Neutrophil_FC-PV.csv")
write.table(Results, file = "Patient31143_Neutrophil_FC-PV.txt")

# Make a basic volcano plot
Table <- read.table("Patient31143_Neutrophil_FC-PV.txt", header=TRUE)
head(Table)
with(Table, plot(log2FoldChange, -log10(pvalue), pch=1, main="Patient 31143 Neutrophil"))

# Add colored points green if pvalue<.01 (alias -log10(pvalue)<2) and FoldChange>1.3
a <- log2(1.3);
with(subset(Table, pvalue>.01 | abs(log2FoldChange)<a), points(log2FoldChange, -log10(pvalue), pch=1, col="gray"));
with(subset(Table, pvalue<.01 & abs(log2FoldChange)>a), points(log2FoldChange, -log10(pvalue), pch=20, col="black"));
abline(v=c(+a,-a), col=c("black", "black"), lty=c(2,2), lwd=c(1, 1));
abline(h=2, col=c("black", "black"), lty=c(2,2), lwd=c(1, 1));


Significant <- subset(Table, pvalue<.01 & abs(log2FoldChange)>a)
write.csv(Significant, file = "Patient31143_Significant_Neutrophils.csv")
