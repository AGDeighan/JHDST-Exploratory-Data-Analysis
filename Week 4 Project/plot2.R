## Import data
nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

## Select data of interest
library(dplyr)
nei <- nei %>% filter(fips == "24510")

## Group and summarise data
nei <- group_by(nei, year)
year_totals <- summarise(nei, Total_Emissions = sum(Emissions)/1000)

## Plot data
png("plot2.png")
plot(year_totals$year, year_totals$Total_Emissions, 
     axes = FALSE,
     xlab = "Year",
     ylab = "Total Emissions (thousands of tons)",
     main = "Decrease in Total Fine Particulate Emissions in Baltimore, MD: \n 1999 - 2008",
     cex.main = 1,
     pch = 19,
     ylim = c(1,4))
box()
regline <- lm(year_totals$Total_Emissions ~ year_totals$year)
abline(regline, col = "blue", lwd = 2, lty = 2)
axis(1, at = seq(1999, 2008, by = 3))
axis(2, at = seq(1, 4, by = 0.5),
     labels = c(1, "", 2, "", 3, "", 4))
legend("topright",
       legend = "Linear Regression of Total Emissions by Year",
       col = "blue",
       lty = 2,
       lwd = 2,
       bty = "n")
dev.off()