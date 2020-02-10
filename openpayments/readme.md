Open Payments data
Notes by: MaryJo Webster
Source:  http://www.cms.gov/OpenPayments/Explore-the-Data/Dataset-Downloads.html
Date: June 30, 2015 – CMS released partial 2013 (5 months’ worth) and complete 2014 data
Server location: amazon1\healthcare
--tables all start with “docpay”
Primary Tables:
General_2014 – general payment records provide the total value of general payments or other transfers of value to a particular recipient for a particular date. For calendar year 2014.
Research_2014 – total value of a payment or other transfer of value made for research purposes to a particular recipient on a particular date. For calendar year 2014
Ownership_2014 – information on physician ownership or investment interests in an applicable manufacturer or applicable GPO
Sup_2014 – physical supplemental detail – all of the identifying information for physicians who were identified as recipients of payments, other transfers of value, or ownership and investment interest in Open Payments records as well as principal investigators who were associated with payments or other transfers of value.
There is a .sql file in the openpayments directory (where this readme is located) that has queries for building tables that we used – such as one for just Minnesota doctors, another for Minnesota companies that made payments; and another that was used for the dataviz. 
Note: the “docpay_old” database on stnewsdb3 has the data that was released in 2013, but was incomplete and generally not usable. The structure of those files are slightly different than the new ones too
There’s also a three-ring binder with the CMS record layout notated to match the table structures and copies of the table scripts and analysis scripts that I used
NOTES:
The download from the CMS website took forever. The biggest file took almost an hour to download. 
I also saved a series of queries that I ran to generate some data files for the reporter. This file also includes some basic cleanup like trimming and setting up indexes. 
The supplemental table (sup_2014) is supposed to have one record for each physician and have more detail about each one. I intended to use that table to pull names from, but I had a really hard time matching that table to general and research. I kept losing records and I never quite figured out the problem. Since I was on deadline and didn’t have time to mess with it, I just used the names as they appeared in the general and research tables. Of course, I ran the risk of having multiple spellings of same name, but on the surface at least, the data looks surprisingly  well standardized.
Jeff Hargarten made a very quick data tool that allows readers to look up payments to Minnesota doctors (anyone that has a license to practice in the state). 
http://www.startribune.com/explore-payments-made-to-minnesota-doctors/311332751/
We had to summarize the data, though, because the tools he used to build it (Google Sheets, primarily) had strict size limits. So instead of showing individual payments like the underlying data does, this tool summarizes the payments by the company making the payment and the nature of the payment (i.e. Dr. Smith received $X from Medtronic for travel & lodging; and he received $X from Medtronic for consulting fees, etc)
