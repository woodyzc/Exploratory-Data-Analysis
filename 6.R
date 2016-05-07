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
sum_bal$city<-'Baltimore'


#filter motor vehicle emissions from Los Angeles.
motor_pm_la<- filter(pm,type=='ON-ROAD',fips=='06037')
motor_pm_la<- group_by(motor_pm_la,year)
sum_la<- summarise(motor_pm_la,Emissions=sum(Emissions))
sum_la$city<-'Los Angeles'

#combind both dataframes from baltimore and los angeles
sum<- rbind(sum_la,sum_bal)

#generate png file
png(filename='plot6.png')
ggplot(sum,aes(year,Emissions))+facet_grid(.~city)+geom_line(lwd=2)+ylab('pm2.5 emissions(tons) per year')+geom_point(aes(year,Emissions),size=6)+ ggtitle('Total Emissions of pm2.5 from Motor Vehicle in Baltimore and LA')
dev.off()