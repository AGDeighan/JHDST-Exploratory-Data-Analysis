## Import data
nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

## Look at data
dim(nei); dim(scc)
str(nei); str(scc)
table(nei$Pollutant)
length(unique(nei$SCC))

## Group and summarise data
library(dplyr)
nei <- group_by(nei, year)
year_totals <- summarise(nei, Total_Emissions = sum(Emissions)/1000000)

## Plot data
png("plot1.png")
plot(year_totals$year, year_totals$Total_Emissions, 
     axes = FALSE,
     xlab = "Year",
     ylab = "Total Emissions (millions of tons)",
     main = "Decrease in Total Fine Particulate Emissions in the United States: \n 1999 - 2008",
     cex.main = 1,
     pch = 19,
     ylim = c(3,8))
box()
regline <- lm(year_totals$Total_Emissions ~ year_totals$year)
abline(regline, col = "blue", lwd = 2, lty = 2)
axis(1, at = seq(1999, 2008, by = 3))
axis(2, at = seq(3, 8, by = 0.5),
     labels = c(3, "", 4, "", 5, "", 6, "", 7, "", 8))
legend("topright",
       legend = "Linear Regression of Total Emissions by Year",
       col = "blue",
       lty = 2,
       lwd = 2,
       bty = "n")
dev.off()
