Death certificate data:

Request data from Minnesota Department of Health. You need to fill out a request form.  A copy of a recent one is included here. That goes to a unit that then passes it on to one of their data people. In recent years we've been working with Neeti Sethi, who is fabulous. They charge $20 per year, even if you ask for multiple years of data in one batch. Generally you don't need to deal with the media people, although they could help if you run into trouble.

See separate text file with the list of the fields that we request each year. Neeti has created a query that matches our file structure and the fields come through matching previous years consistently. I fear that this might change if Neeti leaves or no longer works with us.  The import procedures documented below are set up to work with that table structure. 

The data is all on the Amazon server, in newsroomdata. Tables: deaths_main, deaths_icd, deaths_race, deaths_other. I have a saved query that has all the import specs and updates that need to be run. I saved a backup of it here on github (updated in Feb 2020)

The data comes as one big flat file, but I've split it into these separate relational tables in order to make it more manageable, especially for Uniquery. The table "deaths_main" has all the fields you'd need for Uniquery and is generally the go-table for anything. 

Deaths_other contains all the extraneous stuff we hardly ever use -- name of funeral home, burial/cremation info, etc. 

Deaths_race contains the huge set of race/ethnicity fields that MDH is now using. 

And deaths_icd has multiple records for each death -- one for each ICD code that was listed on their death certificate. Most people only have two or three. But it can be up to 20 codes. I converted it to this structure so it's easier to search and find all the people who had a particular code. 

I also saved an Excel file with the record layouts that I used for writing a lot of the queries, including matching to the older data.  It's useful to check any incoming data against the file structure because occasiionally they change the field names or put a field in the wrong order. Neeti Sethi, one of their data people, has been running all the requests for me lately and she's got it down to a fine art these days.  

In August 2017 I requested a whole new run of data from 2000 to 2015 because I kept finding so many holes in the old data (like the gender field completely blank for all records). So currently the 2000 to 2016 data is very solid. the data starts to get shaky prior to that, particularly in terms of what fields of information we have. We didn't always get everything.

