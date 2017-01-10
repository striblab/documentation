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

On STNCAR is an SSIS package (C:\Users\webstmj\Documents\visual studio 2010\Projects\integration services project 2) set up to import that .csv file into the stsqlnewsusr server in the "db_news_sandbox1" database. It also has a SQL component to run a bunch of cleanup queries.

Currently that server only holds the 2015 data. All older data (plus the 2015 data) resides on stnewsdb1. 

In the "db_news_sandbox1" database, the death tables all start with "deaths" prefix. "Deaths_original" is the table structure for the import. The import process later splits the file into "deaths_main", "deaths_other" and "deaths_ICD". Deaths_Main is used for Uniquery. 

Make sure the .csv file is in D:\vitalRecords on stncar

** Right now the 2015 data is in the "deaths_original_2015" table. Will either need to rename that data (for long-term storage) and create a new blank file with that name for the next import or reconfigure the import process to import to a different named file (leaving the "deaths_original" as the long-term storage site. If so, then you'd need to add a step that moves the 2016 data into the long-term storage, as well). There is also a deaths2010_2014_revisedKEEP table that is data I got in May 2016 to replace those years in our database and to make them better match the 2015 data. This file contains more fields than what they had given us in the 2015 data and they gave us different field names. So when the 2016 data comes out, it will be important to ask MDH for a specific set of fields and that they stick to the same field names!!!

The text file called "deaths split files" has the SQL that I used to split the "deaths_original" into main and other. Again, you'll need to figure out what to do with the 2015 data before you dump in the 2016 data. Keep in mind that you will have to move the Main records to the server for Uniquery and you'll only want to have to move the new stuff (not older years). So need to work out best procedure for that.

That text file also includes the SQL for pulling out the ICD codes. Then I put that in Excel and did Tableau reshaper to normalize it. There is probably a more efficient way to do this. 

I also saved an Excel file with the record layouts that I used for writing a lot of the queries, including matching to the older data that was on stnewsdb1.  Most of that won't be necessary any more since I did all that heavy lifting this time. 

A couple notes on the older data:
I had to re-import the 2001 data because there were so many problems. wrong information had been dropped in the wrong fields due to problematic text qualifiers. Luckily we had the original file, which I cleaned up in UltraEdit, and then brought into SQL. I only put the new records in the new "deaths_main" and "deaths_other" tables on stnewsdb1. The 2001 data that is in the older tables (dmain, lcause, linjury, etc) is unchanged. I'm planning to delete those tables shortly, however.

Uniquery is now pointing at deaths_main from stnewsdb1
