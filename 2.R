#load dplyr and ggplot2 package
library(dplyr)
library(ggplot2)

# read in both rds files
pm<- readRDS('summarySCC_PM25.rds')
scc<- readRDS('Source_Classification_Code.rds')

# merge both file by 'SCC' column
pm<- merge(pm,scc,by = 'SCC')
pm<- tbl_df(pm)

#filter to find out emission for baltimore city, then group and summarise by year
bal_pm<- filter(pm,fips=="24510")
bal_pm<- group_by(bal_pm,year)
sum_pm<- summarise(bal_pm, Emission_sum=sum(Emissions))

#generate the png file
png(filename = 'plot2.png')
plot(sum_pm$year,sum_pm$Emission_sum,xlab = 'Year',ylab = 'pm2.5 emissions(tons) per year',main = 'Total emission from 1999 to 2008 in Baltimore City',type = 'line',lwd=2,xaxt="n")
points(sum_pm$year,sum_pm$Emission_sum,lwd=6)
axis(1,sum_pm$year)
dev.off()