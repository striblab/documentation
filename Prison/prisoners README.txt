PRISONERS README

***NOTE when updating this data: The tables contain some records from the COMS4 version of the data and these need to be retained after future updates. Any updates we get in the future will replace all records that say the "source" is COMS5, but they won't ever replace the COMS4. See below for more details.****

We get state prisoner data from the Minnesota Department of Corrections. Contact person is Vicki Tholkes, vickie.tholkes@state.mn.us. The person responsible for the data system and most able to answer questions regarding the data is Deb Kerschner.

The data comes from their COMS5 database, which replaced an older version called COMS4. We have some of each data in our system because when the DOC made the switch to the new computer system they only transferred records that were for "active offenses" -- where the person was actively serving their term for that offense. 

So this presented a couple problem scenarios  -- the first being that some people simply weren't in the new database at all. The other is that some people were in the database but didn't have sentence records. 

Note regarding the new system: The biggest change is that they created an "obligation identifier" and there is a table called "obligation" that identifies that primary offense that they are currently serving time for. (In the past they referred to this primary offense as the "governing" offense.)

This dataset is a bit problematic for our purposes because it's used by the DOC as a tracking system, so when we get the data it's essentially a snapshot at that point in time of where everybody was and what offense they were actively serving at the time. It's hard for us to convert that to something that shows that person's history in the prison system.

 The data is stored in stsqlnewsusr server -- in the database called "db_news_sandbox1"
 Tables:
 prison_offender
 prison_alias
 prison_history
 prison_sentence
 prison_obligation
 
 These tables contain the COMS5 data and any COMS4 data that wasn't transferred to the new database. The field called "source" is something I added to distinguish where each record came from
 
 The old COMS4 data (as of when they took that system offline) are also stored on this server. All the tables, including numerous lookup tables, have "coms4" in the name. 
 
 The new data does not need lookup tables because nothing is coded. 
 
 When you get new data:
 * You DON'T want to import directly to the existing tables. Likely will need to rename those tables and make new structures for importing. Then run the bulk insert commands and other SQL that's saved in a separate file also in this directory.
 * Then you'll need to move the COMS4 data over to the new tables. I don't have any saved insert queries for doing this. Should be able to just do something like "insert into prison_offender select * from prison_offender_old where [source]='COMS4'"
 * reindex the tables
 * run query to build table for Uniquery
 
 
 
 