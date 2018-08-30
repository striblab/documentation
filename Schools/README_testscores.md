The main copy of this is stored on github/striblab/documentation/schools

# Data source

The Minnesota Comprhensive Assessment scores are released by the Minnesota Department of Education, sometime in the summer each year. Sometimes they provide embargo access to media the day before it is released publicly. (They did not for 2018)

## Downloading data

You can find the data files in the [MDE data center](http://w20.education.state.mn.us/MDEAnalytics/Data.jsp).

1. Go to the "Assessment and Growth Files" section: http://w20.education.state.mn.us/MDEAnalytics/DataTopic.jsp?TOPICID=1
1. For "Test Name" choose: `MCA`
1. A list will appear, for your relevant year, probably the most recent, download where:
   - Public schools
   - Subject is Math or Reading
   - `Tab` format data file

For example purposes, we will download these to the following locations relative to this project folder.

- `sources/2018MCA3MathPublicFilter9.tab`
- `sources/2018MCA3ReadingPublicFilter9.tab`

## About the data

There are multiple rows of data for each school, each district, and then county-level and state-level results, too.

## Data storage

Data starting in 2000-01, going forward, are stored on the DataDrop MySQL Amazon server in the `Schools` database.

The main table where this data is stored is the `mca` table.

## Import data

The example import script is at `import mca script.example.sql`. Some updates need to happen to make this work.

1. Update the file name location to where you put the tab-delimited files.
1. Check that the field names in the tab-delimited files match the field names in the import script.
1. Run each query separately. It is suggested to run

In this repository is a SQL script called "import MCA script" that has the code for loading the two files into the MCA table. At the bottom there's an update query for populating the schoolid field that also needs to be done.

## Analysis

Use the SQL script called `queries for test score analysis.sql`; this has a series of queries that either summarize the data in various ways, or spit out chunks of data that reporters have wanted in the past. For example, one chunk pulls out school-level results for a single district.

Some of the queries require editing.

- Certain queries you'll need to edit the where line to get different districts. They will likely want:
  - Minneapolis (`districtnumber=0001`, `districtype=03`)
  - St. Paul (`districtnumber=0625`, `districttype=01`)
  - Anoka-Hennepin (`districtnumber=0011`, `districttype=01`)

The queries should be output into an Excel file for reporters and editors to review, and possibly used for graphics.

## Beating the odds

To get the data for Jeff's dataviz: The R script called "process\_\_test_score_data.R" will pull the data from mySQL (this takes a little while to run) and then it does a bunch of joining and runs the regression analysis. When it's finished, it will spit out a csv file to your working directory called "mca_dataviz.csv". This file can replace the existing data in Jeff's dataviz.

The main thing to watch for on this is to see if the regression ran ok -- the fields called predicted, residual and categoryname should be populated for all records. I tested this using last year's data and it ran perfectly, so it should be fine.

ADDITIONAL NOTES:
there are tables that I created, called schoollist and districtlist, that are lookup tables with one record for each school (or district); this is where I've added some additional info that we find useful, such as whether the school/district is in the 7-county metro and things like that; Each year those tables need to be updated to add new schools/district. Would also be useful going forward to flag any schools/districts that are in those lists that are no longer operating.

Before the new data arrives, be sure to get updated files on special population enrollment from MDE and import those to the "specialenroll" table
You can also use this to figure out which schools/districts need to be added to the schoollist and districtlist tables. Also check to
for any name changes.

Look at the saved queries in "queries for test score analysis.sql" to see if they will be sufficient for the schools reporters. Most of the queries in there are meant to generate data that reporters can use for their story. Adjust as needed.

UniqueID= schoolID+"-"+datayear+"-"+subject.

When new MCA data arrives:

- Import the new data
- Make sure schoollist and districtlist tables are updated
- Analysis, regression and dataviz output are all set up in an R project called "TestScoreRegression" ; stored in MaryJo's OneDrive.

Proficiency definition:
Prior to the 05-06 school year, there were 5 proficiency levels. Levels 3, 4, and 5 were considered "proficient" (or above). Starting in 05-06, they dropped down to four levels. Now levels 3 and 4 are considered proficient.
