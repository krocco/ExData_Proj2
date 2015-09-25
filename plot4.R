## Created by Peter Michael Crocco for Exploratory Data Analysis (exdata-032)
# 25/09/2015
## Create a plot to investigate coal combustion related PM2.5 Emissions "across the US"
# assume "across the US" means for the whole of the United States

library(dplyr)
library(ggplot2)
## Read in the files after confirming they exist in the working directory

NEI.filename <- "summarySCC_PM25.rds"
SCC.filename <- "Source_Classification_Code.rds"

if(all(file.exists(c(NEI.filename, SCC.filename)))) {
        NEI <- readRDS(NEI.filename)
        SCC <- readRDS(SCC.filename)
}else {print("One or more files missing")}

# Convert to a dplyr data table
nei <- tbl_df(NEI)
rm("NEI")
scc <- tbl_df(SCC)
rm("SCC")

# Find all SCC entries which mention coal
scc.coal <- filter(scc, grepl("coal", ignore.case=TRUE, Short.Name))

# Summarize emissions: group by year, filter for SCC which appears in scc.coal
# and sum emissions

result <- 
        nei %>%
        group_by(year) %>%
        filter(SCC  %in% scc.coal$SCC) %>%
        summarize(totalEmissions = sum(Emissions))

# plot a chart with 4 data points, fit a linear regression
qplot(year, totalEmissions, data = result, geom = c("point","smooth"),
      method = "lm", ylab = "Coal Emissions", main = "Total Coal PM2.5 in USA")
ggsave(file = "plot4.png", width=3, height=3, dpi=200)
