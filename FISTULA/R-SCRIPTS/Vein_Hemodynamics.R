# Read the hemodynamic data set
Hemodynamics <- read.csv(file="Hemodynamics_Fistula-Vein.csv", head=TRUE, sep=",")
str(Hemodynamics)

## Load
library(lattice)
par(cex = .6)
options(scipen=999)  # turn-off scientific notation like 1e+48

#--Define plot titles:
lab.Scan.1 <- "Baseline"
lab.Scan.2 <- "6 weeks"
lab.Scan.3 <- "6 months"

#--Custom strip function:
my.strip <- function(which.given, which.panel, ...) {
  strip.labels <- c(lab.Scan.1, lab.Scan.2, lab.Scan.3)
  panel.rect(0, 0, 1, 1, col="#ffe5cc", border=1)
  panel.text(x=0.5, y=0.5, adj=c(0.5, 0.55), cex=0.95,
             lab=strip.labels[which.panel[which.given]])}

#Create and save plots
pdf(file="AllPatients_vein_Area.pdf")
xyplot(area ~ d.mm | Scan, data = Hemodynamics, groups = Patient, type = "l", lwd=0.5, grid = TRUE, 
       strip=my.strip, layout=c(1, 3, 1), xlab="Vein Length [mm]", ylab="Area [mm^2]")
dev.off()

pdf(file="AllPatients_vein_WSSave.pdf")
xyplot(WSSave ~ d.mm | Scan, data = Hemodynamics, groups = Patient, type = "l", lwd=0.5, grid = TRUE,
       strip=my.strip, layout=c(1, 3, 1), xlab="Vein Length [mm]", ylab="Average of WSS [Pa]")
dev.off()

pdf(file="AllPatients_vein_WSSmax.pdf")
xyplot(WSSmax ~ d.mm | Scan, data = Hemodynamics, groups = Patient, type = "l", lwd=0.5, grid = TRUE,
       strip=my.strip, layout=c(1, 3, 1), xlab="Vein Length [mm]", ylab="Maximum WSS [Pa]")
dev.off()

pdf(file="AllPatients_vein_WSSGave.pdf")
xyplot(WSSGave ~ d.mm | Scan, data = Hemodynamics, groups = Patient, type = "l", lwd=0.5, grid = TRUE,
       strip=my.strip, layout=c(1, 3, 1), xlab="Vein Length [mm]", ylab="Average of WSS gradient [1/Pa]")
dev.off()

pdf(file="AllPatients_vein_OSI.pdf")
xyplot(OSI ~ d.mm | Scan, data = Hemodynamics, groups = Patient, type = "l", lwd=0.5, grid = TRUE, 
       strip=my.strip, layout=c(1, 3, 1), xlab="Vein Length [mm]", ylab="Oscillatory Shear Index")
dev.off()
