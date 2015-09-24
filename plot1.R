## Created by Peter Michael Crocco for Exploratory Data Analysis (exdata-032)
# 24/09/2015
## Create a plot to investigate whether total PM2.5 emissions have decreased
# between 1999 and 2005. Only 4 years of data exist, so a simple bar chart should be 
# sufficient.

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
# Group by year and summarize totals
nei_byYear <- group_by(nei, year)
emissionsByYear <- 
        nei %>%
        group_by(year) %>%
        summarize(totalEmissions = sum(Emissions))

# the data is only 4 points, create a bar chart of total emissions vs year

png(file = "plot1.png")
barplot(emissionsByYear$totalEmissions/1000, names.arg = emissionsByYear$year,
        main = "Total PM2.5 Emissions from All Sources", xlab = "year",
        ylab = "emissions (kilotons)")
dev.off()