#updated August 2018


#The table called "districtlist" has one row for each district and it identifies whether the district is in the 7-county
#metro area and also it's "location" (corecities=located in Minneapolis or St Paul; suburbs is the suburban cities of the 7-county
# and "out state" is everywhere else)

#There is also a table called "schoollist" that has one row for each school and it also identifies whether in metro and it's location

#use those 2 tables in joins to MCA whenever need to restrict results to only metro area


#Field called "districttype" identifies charter schools (type=07). The "traditional" districts are type=01 or type=03. Anything with some other 
#number are speciality districts that we generally don't pay much attention to

#The schooltype or school classification fields tell you if it's elementary, middle, senior high, etc. 

#In the MCA table, there are multiple rows for each GRADE in each school, plus separate records at the district level and the state level and county LEVEL
#see the "summarylevel" field to know which records are which




##This query generates the sub-group totals for statewide; also useful for looking at opt-out rates
#districtnumber 9999 represents all schools statewide
#Limited to 05-06 and newer years due to changes in the tests

select  datayear, subject, reportcategory, reportdescription, sum(counttested) as NumTested, sum(countlevel1) as NumLev1, 
sum(countlevel2) as NumLev2, sum(countlevel3) as NumLev3, sum(countlevel4) as NumLev4, sum(countlevel3)+sum(countlevel4) as NumProficient,
sum(countabsent) as NumAbsent, sum(countMedExempt) as NumExempt, sum(CountRefused) as NumRefused, sum(gradeEnrollment) as Enrollment 
from mca
where districtnumber='9999' and (subject='M' or subject='R') and datayear>='05-06'
group by datayear, subject, reportcategory, reportdescription
order by datayear, subject, reportcategory, reportdescription



#This pulls out the race/ethnicity results to use for looking at achievement gap
#note: they changed the categories a few years ago, splitting Pacific Islander off from Asian and creating 2 or more race field
select  datayear, subject, reportdescription, sum(counttested) as NumTested, sum(countlevel1) as NumLev1, 
sum(countlevel2) as NumLev2, sum(countlevel3) as NumLev3, sum(countlevel4) as NumLev4, sum(countlevel3)+sum(countlevel4) as NumProficient,
(sum(countlevel3)+sum(countlevel4))/sum(countTested) as PctProficient 
from mca
where districtnumber='9999' and (subject='M' or subject='R') and reportCategory='Race/Ethnicity' and datayear>='05-06'
group by datayear, subject,  reportdescription
order by subject, reportdescription, datayear

#look at poor kids versus not poor kids is another way to look at the achievement gap
select  datayear, subject, reportdescription, sum(counttested) as NumTested, sum(countlevel1) as NumLev1, 
sum(countlevel2) as NumLev2, sum(countlevel3) as NumLev3, sum(countlevel4) as NumLev4, sum(countlevel3)+sum(countlevel4) as NumProficient,
(sum(countlevel3)+sum(countlevel4))/sum(countTested) as PctProficient 
from mca
where districtnumber='9999' and (subject='M' or subject='R') and reportCategory like '%Economic%' and datayear>='05-06'
group by datayear, subject,  reportdescription
order by subject, reportdescription, datayear



#This generates the 2 records needed to add to the graphic data -- "statewide proficiency over time.xlsx"
select datayear, subject, sum(counttested) as TotTested, sum(countlevel3) as TotLev3, sum(countlevel4) as TotLev4, 0 as TotLev5,
sum(countlevel3)+sum(countlevel4) as Countprof, (sum(countlevel3)+sum(countlevel4))/sum(countTested) as PctProficient
from mca
where datayear='17-18' and districtnumber='9999' and reportorder='1'
group by datayear, subject



##This query pulls out the sub-group info (like above), except it is at the district level FOR METRO AREA ONLY
#this allows reporters to look at sub-groups within districts; grades are all collapsed
#put this in an Excel file for reporters
#Can exclude charter schools by adding this to the where line:  districtType<>'07'

select  location, mca.districtname, datayear, subject, reportcategory, reportdescription, sum(counttested) as NumTested, sum(countlevel1) as NumLev1, 
sum(countlevel2) as NumLev2, sum(countlevel3) as NumLev3, sum(countlevel4) as NumLev4, sum(countlevel3)+sum(countlevel4) as NumProficient
from mca inner join DistrictList on schoolid=IDnumber
where filtered='N' and (subject='M' or subject='R') and datayear>='15-16' and summarylevel='district'
and metro7county='yes'
group by mca.districtname, datayear, subject, reportcategory, reportdescription



#district level results; not summarized in any way
select datayear, districtnumber, districtType, districtname, schoolnumber, schoolname, grade, subject, reportorder, reportCategory, 
ReportDescription, filtered, counttested, countLevel3+countLevel4 as NumProficient 
from mca
where (subject='M' or subject='R') and datayear>='05-06' and schoolnumber='000' and filtered='N'


#compare 3rd grade over the years at statewide LEVEL
#I'll be using these queries for a future story
select datayear, subject, sum(counttested) as NumTested, sum(countlevel3)+sum(countlevel4) as NumProficient
from mca
where filtered='N' and datayear>='05-06' and summarylevel='state' and grade='03'
group by datayear, subject

#how many kids in poverty each year in third grade; does that help explain why scores have come down?
select datayear, sum(freek12)+sum(redk12) as Freelunch, sum(k12enr) as TotEnroll
from enroll_special
where grade='03'
group by datayear


##This query pulls out school-level results (grades are collapsed) for schools in the metro area; 
#excludes the special education and alternative learning schools
#includes only 2 most recent years of data

SELECT        SchoolList.SchoolID, SchoolList.districtname_new, SchoolList.SCHOOLNAME_NEW, SchoolList.Metro7county, SchoolList.Location, 
                         SchoolList.SchoolType, mca.dataYear, mca.subject, sum(mca.countTested) as numtested, sum(mca.countLevel3)+sum(mca.countLevel4) as NumProf,
						 sum(countabsent) as NumAbsent, sum(countMedExempt) as NumExempt, sum(CountRefused) as NumRefused, sum(gradeEnrollment) as Enrollment 
FROM            mca INNER JOIN
                         SchoolList ON mca.schoolid = SchoolList.SchoolID
where filtered='N' and reportorder='1' and metro7county='yes' and SchoolList.classification<'41' AND (SUBJECT='m' OR SUBJECT='R')
and (datayear='16-17' or datayear='17-18')
group by SchoolList.SchoolID, SchoolList.districtname_new, SchoolList.SCHOOLNAME_NEW, SchoolList.Metro7county, SchoolList.Location, 
                         SchoolList.SchoolType, mca.dataYear, mca.subject


##This pulls out school-level results for all schools in a given district
#includes just most recent 2 years of data
#Minneapolis (districtnumber=0001, districtype=03) 
#St. Paul (districtnumber=0625 and districttype=01) 
#Anoka-Hennepin (districtnumber=0011 and districttype=01)

select mca.schoolid, schoolname_new, schooltype, datayear, subject, reportorder, reportcategory, reportdescription, filtered, sum(counttested) as NumTested,
 sum(countlevel1) as NumLev1, sum(countlevel2) as NumLev2, sum(countlevel3) as NumLev3, sum(countlevel4) as NumLev4, sum(countlevel3)+sum(countlevel4) as NumProf,
(sum(countLevel3)+sum(countLevel4))/sum(counttested) as PctProficient,
sum(countabsent) as NumAbsent, sum(countMedExempt) as NumExempt, sum(CountRefused) as NumRefused
from mca left join SchoolList on mca.schoolid=SchoolList.schoolid
where mca.districtnumber='0001' and mca.districttype='03' and filtered='N' and datayear>='16-17'
group by mca.schoolid, schoolname_new, schooltype, datayear, subject, reportorder, reportcategory, reportdescription, filtered
order by datayear, subject, schoolid, reportorder


##This pulls sub-group summary data for a single district
#Change districtnumber and districttype to change to a different district
select  districtname, datayear, subject, reportcategory, reportdescription, sum(counttested) as NumTested, sum(countlevel1) as NumLev1, 
sum(countlevel2) as NumLev2, sum(countlevel3) as NumLev3, sum(countlevel4) as NumLev4, sum(countlevel3)+sum(countlevel4) as NumProficient,
sum(countabsent) as NumAbsent, sum(countMedExempt) as NumExempt, sum(CountRefused) as NumRefused, sum(gradeEnrollment) as Enrollment 
from mca
where districtnumber='0011' and districttype='01' and filtered='N'
group by districtname, datayear, subject, reportcategory, reportdescription
order by districtname, datayear, subject, reportcategory, reportdescription


##############OPT OUT RATES


#This pulls out the key fields you will need, summarized to the state level, for looking at opt-out rates over time

SELECT DATAYEAR, GRADE, SUBJECT, SUM(countabsent) AS absentt, SUM(countMedExempt) as exempt, SUM(CountRefused) as refused, sum(counttested) as tested, sum(countinvalid) as invalid, sum(countnotcomplete) as notcomplete, 
sum(countRefusedParent) as parent, sum(countRefusedStudent) as student, sum(countwronggrade) as wronggrd, sum(gradeenrollment) as OctEnroll
from mca 
where reportorder='1' and districtnumber='9999'
group by datayear, grade, subject


#This pulls out school-level counts to look at opt-out rates by school, just for the most current year

select districtname, schoolname, subject, SUM(countabsent) AS absentt, SUM(countMedExempt) as exempt, SUM(CountRefused) as refused, sum(counttested) as tested, sum(countinvalid) as invalid, sum(countnotcomplete) as notcomplete, 
sum(countRefusedParent) as parent, sum(countRefusedStudent) as student, sum(countwronggrade) as wronggrd, sum(gradeenrollment) as OctEnroll
from mca
where reportorder='1' and datayear='17-18' and schoolnumber<>'000'
group by districtname, schoolname, subject
order by 4 desc














