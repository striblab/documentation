# Voter registration and history data

Request new data access at the beginning of each calendar year. Fill out the request form, in this repository, and send to either the PIO or Bert Black at the Secretary of State's office, along with a check. 

That will provide us FTP access to the data, updated at the start of each quarter

# Import process:
The Minnesota Secretary of State’s office will post data for us to their FTP server the first week of each quarter of the year – so the first week of January, first week of April, first week of July, and first week of October. 

The FTP site is ftp.sos.state.mn.us   usually works best with FTP client software (wsftp, cuteftp, cyberduck, winscp, etc) 

There will be 18 compressed files.
--The 8 starting with “st_election” are for a voting history table (all files have same layout)
--The 8 starting with “st_voter” are for a voter registration table (all files have same layout)
--The other – ST_PFlist and ST_PPlist – will not be imported to Uniquery, but they are good to have on hand for other uses. So they should just be downloaded. 
The files are all comma-delimited with double quotes as text qualifers


Directions to import the voter registration files to MySQL:
--Export to a .csv the existing data that is in the "VoterReg_Current" table on amazon1 server/newsroomdata database. I'm storing all these archive files in a zip file (need to find a good home for them, however)
--Unzip the text files to a directory where you have lots of space
--In the newsroomdata database on amazon1 there is a saved query called "voters_importqueries" that has the import script. (A backup copy of it is stored in this github repo)
--There are 8 "load data" commands -- one for each of the text files. You'll need to check that the path listed for each script matches where you stored the 8 text files. 
--Once the .csv export of the existing data is complete, then go ahead and run the whole script. As long as all 8 text files are unzipped they should import one after another; at the end of the script are a couple update queries that populate the Address field (combining the housenumber, address and apartment number) and populate the countyname (by converting the code to a name)
--Check on the indexes and reorganize if necessary
