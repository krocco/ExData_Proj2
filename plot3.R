## Created by Peter Michael Crocco for Exploratory Data Analysis (exdata-032)
# 24/09/2015
## Create a plot to investigate whether which sources (type) have seen decreases
# in PM 2.5 emissions in Baltimore city 

library(dplyr)
library(ggplot2)
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

# summarize the data, filter for Baltimore City, group by year, and source (type)

result <- 
        nei %>%
        group_by(year, type) %>%
        filter(fips == "24510") %>%
        summarize(totalEmissions = sum(Emissions))

# the data is only 4 points, create a bar chart of total emissions vs year
qplot(year, totalEmissions, data = result, geom = c("point","smooth"),
      method = "lm") + facet_wrap(~type)
ggsave(file = "plot3.png", width=4, height=4, dpi=200)
#dev.off()