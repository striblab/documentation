Death certificate data:

Request data from Minnesota Department of Health. No cost. Be sure to have them put it in our Dropoff site. (they tried to email it and it was rejected by our system)

Contact person in 2016 was: 
SCOTT SMITH
Public Information Officer
Minnesota Department of Health
Communications Office
p 651 201-5806  |  m 651 503-1440 
Scott.Smith@state.mn.us

See separate text file with the list of the fields that we requested (for the 2015 batch of data). The import procedures documented below are set up to work with that table structure. MUST ASK MDH FOR A SPECIFIC SET OF FIELDS AND THAT THEY USE THE SAME FIELD NAMES FOR EVERY REQUEST!!! they keep giving us different formats.

The data is all on the Amazon server, in newsroomdata. Tables: deaths_main, deaths_icd, deaths_race, deaths_other. I have a saved query that has all the import specs and updates that need to be run. I saved a backup of it here on github (in Aug 2017)

The data comes as one big flat file, but I've split it into these separate relational tables in order to make it more manageable, especially for Uniquery. The table "deaths_main" has all the fields you'd need for Uniquery and is generally the go-table for anything. 

Deaths_other contains all the extraneous stuff we hardly ever use -- name of funeral home, burial/cremation info, etc. 

Deaths_race contains the huge set of race/ethnicity fields that MDH is now using. 

And deaths_icd has multiple records for each death -- one for each ICD code that was listed on their death certificate. Most people only have two or three. But it can be up to 20 codes. I converted it to this structure so it's easier to search and find all the people who had a particular code. 

I also saved an Excel file with the record layouts that I used for writing a lot of the queries, including matching to the older data.  It's useful to check any incoming data against the file structure because occasiionally they change the field names or put a field in the wrong order. Neeti Sethi, one of their data people, has been running all the requests for me lately and she's got it down to a fine art these days.  

In August 2017 I requested a whole new run of data from 2000 to 2015 because I kept finding so many holes in the old data (like the gender field completely blank for all records). So currently the 2000 to 2016 data is very solid. the data starts to get shaky prior to that, particularly in terms of what fields of information we have. We didn't always get everything.

