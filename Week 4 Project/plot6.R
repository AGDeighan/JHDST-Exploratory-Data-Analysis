## Import data
nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

## Merge data frames
m <- merge(nei, scc, by.x = "SCC", by.y = "SCC", all.x = TRUE, all.y = FALSE)

## Use regular expressions to only select emissions data transportation related sources in Baltimore
library(dplyr)
bla <- m %>% filter(fips == "24510" | fips == "06037")
blat <- bla %>% filter(grepl("^Mobile", EI.Sector))

## Group and summarise data
blat <- blat %>% group_by(year, fips)
totals <- summarise(blat, Total_Emissions = sum(Emissions)/100)

## Plot data
library(ggplot2)
png("plot6.png", width = 640, height = 640)

ggplot(totals, aes(year, Total_Emissions)) + 
  geom_point() + 
  facet_wrap(facets = ~ fips, 
             labeller = labeller(fips = c("24510" = "Baltimore City", "06037" = "Los Angeles County"))) +
  geom_smooth(method = "lm", col = "steelblue")  +
  scale_x_discrete(name = "Year", limits = seq(1999, 2008, by = 3)) + 
  labs(y = expression(PM[2.5] * " Emissions (hundreds of tons)")) + 
  labs(title = expression("Changes in Motor Vehicle Related " * PM[2.5] * " Emissions in Baltimore and Los Angeles"))

dev.off()