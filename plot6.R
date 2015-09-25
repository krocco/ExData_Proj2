## Created by Peter Michael Crocco for Exploratory Data Analysis (exdata-032)
# 25/09/2015
## Compare Motor Vehicle Emissions in Baltimore City and Los Angeles County
# to really compare these two, they should be placed on the same graph

# !!ASSUMPTION!!
###   Motor Vehicles refers to any term containing "vehicle" in SCC.Level.Two category

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
scc.vehicles <- filter(scc, grepl("vehicle", ignore.case=TRUE, SCC.Level.Two))

# Summarize emissions: group by year, filter for SCC which appears in scc.vehicle
# and sum emissions

result <- 
        nei %>%
        group_by(year, fips) %>%
        filter(SCC  %in% scc.vehicles$SCC) %>%
        filter(fips == "24510"|fips=="06037") %>%
        summarize(VehicleEmissions = sum(Emissions))


# plot a chart with 4 data points, fit a linear regression
qplot(year, VehicleEmissions, data = result, color = fips, 
      geom = c("point", "smooth"), method = "lm")
ggsave(file = "plot6.png", width=3, height=3, dpi=200)
