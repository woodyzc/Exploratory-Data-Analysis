#load dplyr and ggplot2 package
library(dplyr)
library(ggplot2)

# read in both rds files
pm<- readRDS('summarySCC_PM25.rds')
scc<- readRDS('Source_Classification_Code.rds')

# merge both file by 'SCC' column
pm<- merge(pm,scc,by = 'SCC')
pm<- tbl_df(pm)

#group and summarise by year
pm<- group_by(pm, year)
sum_pm<- summarise(pm, Emission_sum=sum(Emissions))

#generate the png file
png(filename = 'plot1.png')
plot(sum_pm$year,sum_pm$Emission_sum/1000,xlab = 'year',ylab = 'pm2.5 emissions(kilotons) per year',main = 'Total Emission from 1999 to 2008 in the US',type = 'line',lwd=2,xaxt='n')
axis(1,sum_pm$year)
points(sum_pm$year,sum_pm$Emission_sum/1000,lwd=6)
dev.off()