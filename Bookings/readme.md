
We get jail bookings data from the Minnesota Department of Corrections once per year. There is a small fee to run the data request. Contact Vickie Tholkes - vickie.tholkes@state.mn.us to find out the fee and make sure she's stil the contact person. Then you need to get a check cut and write a DPA letter to send along. 

We request the data in about February each year, asking for all bookings from the prior calendar year. 

In 2018, I ended up getting all data back to 1/1/2005 because there were crazy problems with the Client table.  I finally realized that over the years we had accumualted multiple records for the same person and same "detentionfacilityclientnumber" -- which is the unique ID for each person in a particular jail (so if they were booked into Hennepin jail 5 times it would use the same ID number, but if they got booked into Ramsey, there would be a different ID number for that person). 

So I've updated the import script so that it only adds records to the client table that aren't already in the existing client table. 

As a result of this, all our data from prior to 2005 is a mess and I'm not sure how to resolve. It's not included in the main jail bookings tables. In that older data there also seemed to be problems with the other unique ID that is used to connect the detention table to the charge, offense and courtcase tables. There were some agencies that appeared to use the same ID number for multpile cases. This only seems to be the case in the older data. 
