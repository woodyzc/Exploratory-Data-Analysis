#load dplyr and ggplot2 package
library(dplyr)
library(ggplot2)

# read in both rds files
pm<- readRDS('summarySCC_PM25.rds')
scc<- readRDS('Source_Classification_Code.rds')

# merge both file by 'SCC' column
pm<- merge(pm,scc,by = 'SCC')
pm<- tbl_df(pm)

#filter motor vehicle emissions from baltimore city.
motor_pm_bal<- filter(pm,type=='ON-ROAD',fips=='24510')
motor_pm_bal<- group_by(motor_pm_bal,year)
sum_bal<- summarise(motor_pm_bal,Emissions=sum(Emissions))

#generate png file
png(filename='plot5.png')
ggplot(sum_bal,aes(year,Emissions))+geom_line(lwd=2)+ylab('pm2.5 emissions(tons) per year')+geom_point(aes(year,Emissions),size=6)+ ggtitle('Total Emissions of pm2.5 from Motor Vehicle in Baltimore')
dev.off()