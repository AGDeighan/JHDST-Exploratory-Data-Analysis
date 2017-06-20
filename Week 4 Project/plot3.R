## Import data
nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

## Select data of interest
library(dplyr)
nei <- nei %>% filter(fips == "24510")

## Group and summarise data
nei <- nei %>% group_by(year, type)
totals <- summarise(nei, Total_Emissions = sum(Emissions)/1000)

## Plot data
library(ggplot2)
png("plot3.png")

ggplot(totals, aes(year, Total_Emissions)) + 
  geom_point() + facet_wrap(facets = ~ type) + 
  geom_smooth(method = "lm", col = "steelblue") + 
  scale_x_discrete(name = "Year", limits = seq(1999, 2008, by = 3)) + 
  scale_y_discrete(name = expression(PM[2.5] * " Emissions (thousands of tons)"), limits = seq(0, 3, by = 1)) + 
  labs(title = expression("Change in Total " * PM[2.5] * " Emissions for Baltimore, MD by Source Type"))

dev.off()