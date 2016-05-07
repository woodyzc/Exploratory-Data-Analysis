#load dplyr and ggplot2 package
library(dplyr)
library(ggplot2)

# read in both rds files
pm<- readRDS('summarySCC_PM25.rds')
scc<- readRDS('Source_Classification_Code.rds')

# merge both file by 'SCC' column
pm<- merge(pm,scc,by = 'SCC')
pm<- tbl_df(pm)

# filter to find the emission data for baltimore city. then group and summarise 
# by year
bal_pm<- filter(pm,fips=="24510")
bal_pm<- group_by(bal_pm,year,type)
sum_pm<- summarise(bal_pm, Emission_sum=sum(Emissions))

#generate png file, use facet_grid to generating seperate png files for different emission type
png(filename = 'plot3.png',width = 640,height = 480)
ggplot(sum_pm,aes(year,Emission_sum))+ylab('pm2.5 emissions(tons) per year')+facet_grid(.~type)+geom_line()+geom_point(aes(year,Emission_sum))+scale_x_continuous(breaks=seq(1999, 2008, by=3))+ggtitle('Total Emissionsin of pm2.5 in Baltimore')
dev.off()