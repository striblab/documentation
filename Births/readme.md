
Birth certificate data

Source: Minnesota Department of Health
Contact: Scott Smith, public information officer, 651-201-5806; scott.smith@state.mn.us

Request data in January for the just completed prior year. Be sure to give them the list of fields that match the "births_main" table (it is stored in stnewsdb1 and the production copy with just the 2015 data is on stsqlnewsusr)
There's also a births_record layout Excel file that lists the fields.

The 2015 data came as an XLS file. I converted it to a CSV file for ease of import. Also note that the dates came over as "22-MAR-71" and SQL handled them beautifully. Didn't need to do anything special.

On stncar, in the D drive "Vital records" directory, there is a dtsx package for importing the table into "births_main." I didn't pull that into Visual Studio yet to set it up for running again. It's a pretty clean, straightforward import. Possibly the only thing you might want to add to the import is to have it populate the "birthyear" field (which is something I added)

I kept a .sql file with queries I ran to merge the old data with the new and to clean up the data -- mostly the older records. It's highly doubtful that this would be needed in future years because the newer data is so much more consistent and standardized. The problems were all in the older years (like 20+ years ago). 


NOTES:
We were not consistent over the years about which fields we included in this data, so there are many years where we have just the very basic information, especially when it comes to the parents. In 2015, I made sure to get the full information, including the parent birth places and ages. 

For older data, there was a single birthplace field for mothers (and comparable one for fathers) that was sometimes filled in with a country, other times a county, other times a city, other times a combination. I dropped that older data into the mother birth place city and father birth place city fields. 

There are nearly 5,000 records -- from 1989 to 1991 -- where the county of birth is listed as "500". I don't know what that translates to. There isn't a county FIPS code that matches that. The vast majority of them have a question mark for the mother's last name (but first name is filled in); most do have a county listed for the residence county. 

There are also hundreds of records from that older time span where the facility name (where birth occurred) has a numeric code in it. I looked in the original CSV file and it is the same way in there. The majority of the records list a name of a hospital, but some don't. For example, there are 3,117 with the code "258" -- these all are in Hennepin County and say the birth occurred at a hospital, so I'm assuming this is a code for one of the hospitals.

