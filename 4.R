#load dplyr and ggplot2 package
library(dplyr)
library(ggplot2)

# read in both rds files
pm<- readRDS('summarySCC_PM25.rds')
scc<- readRDS('Source_Classification_Code.rds')

# merge both file by 'SCC' column
pm<- merge(pm,scc,by = 'SCC')
pm<- tbl_df(pm)

# find all coal combustion related pm2.5 emissions by text search.
index<- grepl('coal',pm$Short.Name,ignore.case = TRUE)
coal_pm<- pm[index,]

# group and summarise coal combustion related emissions by year.
coal_pm<- group_by(coal_pm,year)
sum<- summarise(coal_pm,Emissions=sum(Emissions))

# generate png file
png(filename='plot4.png')
ggplot(sum,aes(year,Emissions/1000))+geom_line(lwd=2)+ylab('pm2.5 emissions(kilotons) per year')+geom_point(aes(year,Emissions/1000),size=6)+ ggtitle('Total Emissions of pm2.5 in the US')
dev.off()