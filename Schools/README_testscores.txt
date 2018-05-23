The main copy of this is stored on github/striblab/documentation/schools


Data source: The Minnesota Comprhensive Assessment scores are released by the Minnesota Department of Education, around the end of July each year. They typically provide embargo access to media the day before it is released publicly. You need to apply to MDE each year in order to have access to the embargo site. 

Once the data is public, then you can find the data files in the MDE data center under "assessment and growth."

The files come as tab-delimited, with one for reading, one for math and one for science (which we didn't use this year). There are multiple rows of data for each school, each district, and then county-level and state-level results, too. 

Data starting in 2000-01, going forward, are stored on Amazon server in the schools database. Table is called "MCA"

there are tables that I created, called schoollist and districtlist, that are lookup tables with one record for each school (or district);  this is where I've added some additional info that we find useful, such as whether the school/district is in the 7-county metro and things like that; Each year those tables need to be updated to add new schools/district. Would also be useful going forward to flag any schools/districts that are in those lists that are no longer operating.

Before the new data arrives, be sure to get updated files on special population enrollment from MDE and import those to the "specialenroll" table
You can also use this to figure out which schools/districts need to be added to the schoollist and districtlist tables. Also check to 
for any name changes.



Look at the saved queries in "queries for test score analysis.sql" to see if they will be sufficient for the schools reporters. Most of the queries in there are meant to generate data that reporters can use for their story. Adjust as needed.

Go back into the code and create a uniqueID for all records made up of:   schoolID+"-"+datayear+"-"+subject.

When new MCA data arrives:
* Import the new data 
* Make sure schoollist and districtlist tables are updated
* update the schools_currentMCA data view (make sure the where line has the most recent year)
* Analysis, regression and dataviz output are all set up in an R project called "TestScoreRegression" ; stored in MaryJo's OneDrive.


Proficiency definition:
Prior to the 05-06 school year, there were 5 proficiency levels. Levels 3, 4, and 5 were considered "proficient" (or above). Starting in 05-06, they dropped down to four levels. Now levels 3 and 4 are considered proficient.



