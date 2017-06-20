## Import data
nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

## Merge data frames
m <- merge(nei, scc, by.x = "SCC", by.y = "SCC", all.x = TRUE, all.y = FALSE)

## Use regular expressions to only select emissions data from coal combustion related sources
library(dplyr)
f <- m %>% filter(grepl("(.*[Cc][Oo][Aa][Ll].*[Cc][Oo][Mm][Bb].*)|(.*[Cc][Oo][Mm][Bb].*[Cc][Oo][Aa][Ll].*)", Short.Name))

## Group and summarise data
f <- f %>% group_by(year)
totals <- summarise(f, Total_Emissions = sum(Emissions)/1000)

## Plot data
library(ggplot2)
png("plot4.png", width = 640)

ggplot(totals, aes(year, Total_Emissions)) + 
  geom_point() + 
  geom_smooth(method = "lm", col = "steelblue") + 
  scale_x_discrete(name = "Year", limits = seq(1999, 2008, by = 3)) + 
  scale_y_discrete(name = expression(PM[2.5] * " Emissions (thousands of tons)"), limits = seq(300, 600, by = 50)) + 
  labs(title = expression("Decrease in Total Coal Combustion Related " * PM[2.5] * " Emissions in the United States"))

dev.off()