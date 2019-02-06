Hemodynamics <- read.csv(file="Hemodynamics_Fistula-Vein.csv", head=TRUE, sep=",")
View(Hemodynamics)

Patient1 <- filter(Hemodynamics, Patient == "031143 HJ")
#head(Patient1)
View(Patient1)

Baseline <- filter(Patient1, Scan == 1)
Week6 <- filter(Patient1, Scan == 2)
Month6 <- filter(Patient1, Scan == 3)
n <- dim(Baseline);
m <- (n[1]);

FoldChange_Week6 <- Week6[5:9]/Baseline[5:9]
FoldChange_Month6 <- Month6[5:9]/Baseline[5:9]
xdim <- head(Patient1[4:4],m)
#View(xdim)

Patient1_FoldChange_Week6 = cbind(xdim, FoldChange_Week6);
Patient1_FoldChange_Month6 = cbind(xdim, FoldChange_Month6);

#--Define plot titles:
lab.area <- "Area"
lab.WSSave <- "Average of WSS"
lab.WSSmax <- "Maximum WSS"
lab.WSSGave <- "Average of WSS gradient"
lab.OSI <- "Oscillatory Shear Index"

#--Custom strip function:
my.strip <- function(which.given, which.panel, ...) {
  strip.labels <- c(lab.area, lab.WSSave, lab.WSSmax, lab.WSSGave, lab.OSI)
  panel.rect(0, 0, 1, 1, col="#ffe5cc", border=1)
  panel.text(x=0.5, y=0.5, adj=c(0.5, 0.55), cex=0.95,
             lab=strip.labels[which.panel[which.given]])
}

#settings for graph title style
my.settings <- list(
  par.main.text = list(font = 2, # make it bold
                       just = "left", 
                       x = grid::unit(5, "mm")),
  par.sub.text = list(font = 0.5, 
                      just = "left", 
                      x = grid::unit(5, "mm"))
)

#Week 6 fold change graph
pdf(file="Patient31143_FoldChange_Week6.pdf")
xyplot(area + WSSave + WSSmax + WSSGave + OSI ~ d.mm, data = Patient1_FoldChange_Week6, scales=list(y="free", rot=0),type = "l", 
       grid = TRUE, strip=my.strip, outer=TRUE, layout=c(1, 5, 1), xlab="Vein Length [mm]", ylab="",
       main="Patient 331143 - 6 weeks fold change from baseline")
       #par.settings=my.settings, main="Patient 31129 - 6 weeks fold change from baseline",
       #sub="Source: Hemodynamic data-set")
dev.off()

#Month 6 fold change graph
pdf(file="Patient31143_FoldChange_Month6.pdf")
xyplot(area + WSSave + WSSmax + WSSGave + OSI ~ d.mm, data = Patient1_FoldChange_Month6, scales=list(y="free", rot=0),type = "l", 
       grid = TRUE, strip=my.strip, outer=TRUE, layout=c(1, 5, 1), xlab="Vein Length [mm]", ylab="",
       main="Patient 31143 - 6 months fold change from baseline")
dev.off()

#Creating the combined graph
Patient1_FoldChange = 0;
Patient1_FoldChange = rbind(Patient1_FoldChange_Week6, Patient1_FoldChange_Month6);
#View(Patient1_FoldChange)
Scan <- tail(Patient1[3:3],(n[1]*2));
Patient1_FoldChange = cbind(Scan,Patient1_FoldChange);

pdf(file="Patient31143_FoldChange.pdf")
xyplot(area + WSSave + WSSmax + WSSGave + OSI ~ d.mm, data = Patient1_FoldChange, groups = Scan, scales=list(y="free", rot=0),type = "l", 
       grid = TRUE, strip=my.strip, outer=TRUE, layout=c(1, 5, 1), xlab="Vein Length [mm]", ylab="",
       key=list(text=list(c("6 weeks", "6 months")),
                title="Patient 31143 - Fold change from baseline",
                col=c("deepskyblue3", "deeppink"), lty=c(1, 1),
                columns=2, cex=0.7,
                lines=TRUE))
dev.off()
