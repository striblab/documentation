#install.packages("tidyverse", "ggplot2", "lubridate", "reshape2", "tidyr", "janitor", "scales", "knitr","aws.s3", "htmltools", "rmarkdown", "readxl", "DT", "kableExtra", "ggthemes", "RMySQL")


  
#BEFORE RUNNING THIS:
#Make sure SchoolList table is up-to-date





# load required packages
library(readr) #importing csv files
library(dplyr) #general analysis 
library(ggplot2) #making charts
library(lubridate) #date functions
library(reshape2) #use this for melt function to create one record for each team
library(tidyr)
library(janitor) #use this for doing crosstabs
library(scales) #needed for stacked bar chart axis labels
library(knitr) #needed for making tables in markdown page
library(aws.s3)
library(htmltools)#this is needed for Rstudio to display kable and other html code
library(rmarkdown)
library(readxl)
library(DT) #needed for making  searchable sortable data tble
library(kableExtra)
library(ggthemes)
library(RMySQL)



#bring in state level data

#bring in district level data

#bring in data for regression analysis (already summarized)



#for testing purposes pull in these csv files; for live analysis, use connection to Amazon server

#mca_original <- read_csv("mca_original.csv")
#race <-  read_csv("race.csv")
#school_list <-  read_csv("school_list.csv")


#connect to the database; it will launch pop-ups asking for you to supply your username and password
#Change MYDATABASENAME to the name of the database in your server




con <- dbConnect(RMySQL::MySQL(), host = rstudioapi::askForPassword("host"), dbname="Schools", user= rstudioapi::askForPassword("Database user"), password=rstudioapi::askForPassword("Database password"))

#list the tables in the database we've connected to
#dbListTables(con)

#list the fields in the table; change "mytablename" to the name of the table you're trying to connect to
#dbListFields(con,'mytablename')


#Pull MCA data summarized by school
data1 <- dbSendQuery(con, "select * from schools_pullMCA")
mca_original <- fetch(data1, n=-1)

dbClearResult(data1)



#Pull race data
data2 <- dbSendQuery(con, "select * from schools_pullracequery where datayear>='05-06'")
race <- fetch(data2, n=-1)

dbClearResult(data2)

#Pull SchoolList
data3 <- dbSendQuery(con, "select SchoolID, districtType, schoolNumber, districtname_new, SCHOOLNAME_NEW, 
                     Classification, SchoolType, Grades, Metro7county, Location, SchoolLocationCountyName from SchoolList")
school_list <- fetch(data3, n=-1)

dbClearResult(data3)


#pull poverty data
data4 <-  dbSendQuery(con, "select * from schools_freelunch_qry")
poverty <- fetch(data4, n=-1)

dbClearResult(data4)


#pull statewide summaries
#leaves out the filtered categories
data5 <- dbSendQuery(con, "select * from mca where summarylevel='state' and
                     filtered='n' and (subject='M' or subject='R') and datayear>='05-06'")
statewide <- fetch(data5, n=-1)

dbClearResult((data5))


#pull metro district-level results (not summarized)
#this is for 2015-16 to present
#only districts in the 7-county metro
data6 <- dbSendQuery(con, "select * from mca_districtresults")
districts_mca <- fetch(data6, n=-1)

dbClearResult((data6))


#disconnect connection
dbDisconnect(con)

#writing data frames out to csv for testing purposes
#write.csv(mca_original, "mca_original.csv")
#write.csv(race, "race.csv")
#write.csv(school_list, "school_list.csv")


#filtering this down for testing
#school_list <-  school_list %>% select(SchoolID, districtType, schoolNumber, districtname_new, SCHOOLNAME_NEW,                    Classification, SchoolType, Grades, Metro7county, Location, SchoolLocationCountyName)






#join poverty to mca_original
mca_original <- left_join(mca_original, poverty, by=c("schoolid"="schoolid","dataYear"="DataYear"))




#make reading and math subsets for regression
#exclude schools that tested fewer than 25 students
#calculate proficiency percentages


math <-  mca_original %>% filter(subject=='M', cntTested>=25) %>% mutate(numproficient=cntlev3+cntlev4, PctProf= (cntlev3+cntlev4)/cntTested, Notes='Included')

read <- mca_original %>% filter(subject=='R', cntTested>=25) %>% mutate(numproficient=cntlev3+cntlev4, PctProf= (cntlev3+cntlev4)/cntTested, Notes='Included')


#create two files of the schools excluded from the analysis
#these need to be added back to the final data file
math_excluded <-  mca_original %>% filter(subject=='M', cntTested<25)%>% mutate(numproficient=cntlev3+cntlev4, PctProf= (cntlev3+cntlev4)/cntTested, Notes='Less than 25 students tested', predicted=NA_real_,  residual=NA_real_)


read_excluded <- mca_original %>% filter(subject=='R', cntTested<25) %>% mutate(numproficient=cntlev3+cntlev4, PctProf= (cntlev3+cntlev4)/cntTested, Notes='Less than 25 students tested', predicted=NA_real_,  residual=NA_real_)



#Math regression


#build model
math_model <- lm(PctProf ~ PctPoverty, data=math)

#predicted scores
pred_math <- predict(math_model, math)



#add predicted value
math <-  math %>%  mutate(predicted=pred_math)



#add residual
math <-  math  %>% mutate(residual = PctProf-predicted)

#summary(math_model)


#Reading regression


#build model
read_model <- lm(PctProf ~ PctPoverty, data=read)

#predicted scores
pred_read <- predict(read_model, read)

#add predicted value
read <-  read %>%  mutate(predicted=pred_read)

#add residual
read <-  read  %>% mutate(residual = PctProf-predicted)

#summary(read_model)



#Put data files together and add other fields



#union math, read, math_excluded, read_excluded -- call new table testscores
testscores <- rbind(read, math, read_excluded, math_excluded)

#join testscores with race
testscores <-  left_join(testscores, race, by=c("schoolid"="schoolid", "dataYear"="datayear"))

#join testscores/race with school_list
testscores <- left_join(testscores, school_list, by=c("schoolid"="SchoolID"))


#add uniqueID, adjust datayear and grades fields
testscores <- testscores %>% mutate(uniqueID=paste(schoolid,'-',substr(dataYear,1,2),' to ',substr(dataYear,4,6),'-',subject), datayear_new=paste(substr(dataYear,1,2),' to ',substr(dataYear,4,6)), grades_new=paste(substr(Grades,1,2),' to ',substr(Grades,4,6)))


#add category number and description fields - falling short, about as expected, better than expected







testscores <- testscores %>% mutate(categorynum= case_when(residual==NA_real_ ~0, 
                                                           residual<  -0.0951 ~1,
                                                           between(residual, -.0951, .09509)~2,
                                                           residual>  0.09509 ~3, 
                                                           TRUE ~99))

testscores <-  testscores %>% mutate(categoryname= case_when(categorynum==99~"Not enough students tested", categorynum==1~"Falling short", categorynum==2~"As expected", categorynum==3~"Better than expected", TRUE~"99"))

testscores %>% filter(categorynum==99) %>% select(schoolid, PctPoverty, PctProf, predicted, residual, Notes)


#names(testscores)

# Order and rename fields for beating the odds graphic
dataviz_export <-  testscores %>%
  select(uniqueid=uniqueID, 
         SchoolID=schoolid, 
         districtnumber=districtnumber, 
         districttype=districtType.x, 
         schoolnumber=schoolnumber, 
         districtname_new=districtname_new, 
         SCHOOLNAME_NEW=SCHOOLNAME_NEW, 
         Classification=Classification, 
         SchoolType=SchoolType,
         grds=grades_new, 
         Metro7county=Metro7county,
         Location=Location, 
         SchoolLocationCountyName=SchoolLocationCountyName, 
         datayr=datayear_new, 
         subject=subject, 
         cntTested=cntTested, 
         cntlev1, 
         cntlev2, 
         cntlev3,
         cntlev4, 
         numproficient, 
         PctProf, 
         k12enrollment, 
         PctPoverty, 
         pctminority, 
         predicted, 
         residual, 
         Notes, 
         categorynum, 
         categoryname, 
         PovertyCategory)%>%
#rename(districttype=districtType.x, datayr=datayear_new, grds=grades_new)

#export CSV for data visualization
write.csv(dataviz_export, "outputs/beating-the-odds-mca-dataviz.csv")



