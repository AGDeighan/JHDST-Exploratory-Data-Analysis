## Import data
nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

## Merge data frames
m <- merge(nei, scc, by.x = "SCC", by.y = "SCC", all.x = TRUE, all.y = FALSE)

## Use regular expressions to only select emissions data transportation related sources in Baltimore
library(dplyr)
b <- m %>% filter(fips == "24510")
bt <- b %>% filter(grepl("^Mobile", EI.Sector))

## Group and summarise data
bt <- bt %>% group_by(year)
totals <- summarise(bt, Total_Emissions = sum(Emissions)/100)

## Plot data
library(ggplot2)
png("plot5.png", width = 640)

ggplot(totals, aes(year, Total_Emissions)) + 
  geom_point() + 
  geom_smooth(method = "lm", col = "steelblue") + 
  scale_x_discrete(name = "Year", limits = seq(1999, 2008, by = 3)) + 
  scale_y_discrete(name = expression(PM[2.5] * " Emissions (hundreds of tons)"), limits = seq(3, 9, by = 1)) + 
  labs(title = expression("Decrease in Total Motor Vehicle Related " * PM[2.5] * " Emissions in Baltimore, MD"))

dev.off()