# Read the gene expression data set
Monocyte <- read.csv(file="Monocyte.csv",head=TRUE,sep=",")
p <- dim(Monocyte);
Gene <- Monocyte[1:1];
Data <- Monocyte[2:(p[2])];
n <- dim(Data);
m <- ((n[2])/2);

# Calculate the average fold change for each gene from baseline to 2-weeks after fistula
B_means <- rowMeans(Data[1:m]);
W2_means <- rowMeans(Data[(m+1):(n[2])]);
log2FoldChange <- (W2_means - B_means);

# Calculate the p-value of the t-test between baseline and 2-weeks after fistula
Pvalue <- apply(Data, 1, function(Data) {
  t.test(x = Data[1:m], y = Data[(m+1):(n[2])])$p.value});

# Save data
Results = cbind(Gene, log2FoldChange);
Results = cbind(Results, pvalue = Pvalue);
write.csv(Results, file = "Monocyte_FC-PV.csv")
write.table(Results, file = "Monocyte_FC-PV.txt")

# Make a basic volcano plot
Table <- read.table("Monocyte_FC-PV.txt", header=TRUE)
head(Table)
with(Table, plot(log2FoldChange, -log10(pvalue), pch=1, main="Monocyte", xlim=c(-1,1)))

# Add colored points green if pvalue<.01 (alias -log10(pvalue)<2) and FoldChange>1.3
a <- log2(1.3);
with(subset(Table, pvalue>.01 | abs(log2FoldChange)<a), points(log2FoldChange, -log10(pvalue), pch=1, col="gray"))
with(subset(Table, pvalue<.01 & abs(log2FoldChange)>a), points(log2FoldChange, -log10(pvalue), pch=20, col="black"))
abline(v=c(+a,-a), col=c("black", "black"), lty=c(2,2), lwd=c(1, 1))
abline(h=2, col=c("black", "black"), lty=c(2,2), lwd=c(1, 1)) 

Significant <- subset(Table, pvalue<.01 & abs(log2FoldChange)>a)
write.csv(Significant, file = "Significant_Monocytes.csv")
