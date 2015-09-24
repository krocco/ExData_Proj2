## Created by Peter Michael Crocco for Exploratory Data Analysis (exdata-032)
# 24/09/2015
## Create a plot to investigate whether PM2.5 emissions have decreased in
# Baltimore City, Maryland (fips: 24510) from 1999 to 2008

library(dplyr)

## Read in the files after confirming they exist in the working directory

NEI.filename <- "summarySCC_PM25.rds"
SCC.filename <- "Source_Classification_Code.rds"

if(all(file.exists(c(NEI.filename, SCC.filename)))) {
        NEI <- readRDS(NEI.filename)
        #        SCC <- readRDS(SCC.filename)
}else {print("One or more files missing")}

# Convert to a dplyr data table
nei <- tbl_df(NEI)
rm("NEI")

# Group by year , filter by Baltimore City (fips = "24510"), and summarize totals

BaltimoreTotals <- 
        nei %>%
        group_by(year) %>%
        filter(fips == "24510") %>%
        summarize(totalEmissions = sum(Emissions))

# the data is only 4 points, create a bar chart of total emissions vs year
png(file = "plot2.png")
barplot(BaltimoreTotals$totalEmissions, names.arg = BaltimoreTotals$year,
        main = "Total PM2.5 Emissions in Baltimore City, MD", xlab = "year",
        ylab = "emissions (tons)")

dev.off()