--NOTES:
--The format files that came with the data had several errors, including incorrect field widths;
--Just make sure the order of the fields in the new data files matches the order of the tables;
--the field names in the text files dont matter -- they are skipped in this procedure
--the charge and offense tables both had blank rows scattered throughout so the record counts were off
--had trouble getting the last record in the client table to import; ended up making the last field wider and that solved problem
--this script requires data files to be on the stncar virtual server D:\bookings folder
--this assumes the files are comma-delimited with double quotes as text qualifiers; carriage return/new line as EOL markers
--i found some instances in the client table where there were stray commas in the data values
--this data appends to the older data
--the make-table query at the end creates a flat table called "uq_bookings" that needs to be stored on stnewsdb1 to feed Uniquery
--the relational data tables remain on stnewsdb3 (i didn't move them to stnewsdb1)



--STEP 1:
--Rename old table structures

--STEP 2:
--Create new table structures 

CREATE TABLE dbo.tblDetention (
	DetentionFacilityClientNumber nvarchar(50),
	DETNEXTRDetentionID nvarchar(15),
	DetentionFacilityORIIdentifier nvarchar(10),
	DetentionFacilityORIName nvarchar(100),
	DetentionFacilityRegisterIdentifier nvarchar(100),
	DetentionHoldReasonCode nvarchar(3),
	DetentionHoldReasonText nvarchar(100),
	DetentionStartDateTime datetime,
	DetentionEndDateTime datetime,
	DetentionEndReasonCode nvarchar(3),
	DetentionEndReasonText nvarchar(100),
	DetentionControllingAgencyORIIdentifier nvarchar(10),
	DetentionControllingAgencyORIName nvarchar(100),
	DetentionTypeCode nvarchar(3),
	DetentionJuvenileIndicator nvarchar(10)
	);
GO


CREATE TABLE dbo.tblCharge (
	DETNEXTRDetentionID nvarchar(12),
	DetentionOffenseFacilityORIIdentifier nvarchar(10),
	DetentionOffenseFacilityRegisterIdentifier nvarchar(100),
	DetentionOffenseSequenceNumber nvarchar(12),
	DetentionOffenseStatuteChapterCode nvarchar(10),
	DetentionOffenseStatuteSectionCode nvarchar(10),
	DetentionOffenseStatuteSubdivisionCode nvarchar(17),
	DetentionOffenseStatuteSequenceCode nvarchar(10),
	DetentionOffenseMOCcode nvarchar(5),
	DetentionOffenseText nvarchar(150)
	);
GO	


CREATE TABLE dbo.tblCourtCase (
	DETNEXTRDetentionID nvarchar(12),
	DetentionOffenseFacilityORIIdentifier nvarchar(10),
	DetentionOffenseFacilityRegisterIdentifier nvarchar(100),
	DetentionCourtCaseIdentifier nvarchar(100),
	DetentionCourtCaseSentenceStartDate datetime
	);
GO	

CREATE TABLE dbo.tblOffense (
	DETNEXTRDetentionID nvarchar(12),
	DetentionOffenseFacilityORIIdentifier nvarchar(10),
	DetentionOffenseFacilityRegisterIdentifier nvarchar(100),
	DetentionCourtCaseIdentifier nvarchar(100),
	DetentionOffenseSequenceNumber nvarchar(12),
	DetentionOffenseStatuteChapterCode nvarchar(10),
	DetentionOffenseStatuteSectionCode nvarchar(10),
	DetentionOffenseStatuteSubdivisionCode nvarchar(17),
	DetentionOffenseStatuteSequenceCode nvarchar(10),
	DetentionOffenseMOCcode nvarchar(5),
	DetentionOffenseText nvarchar(150)
	);
GO


	 CREATE TABLE dbo.tblClient (
	DetentionFacilityORIIdentifier nvarchar(10),
	DetentionFacilityClientIdentifier nvarchar(20),
	DetentionFacilityClientNumber nvarchar(50),
	ClientFirstName nvarchar(50),
	ClientMiddleName nvarchar(50),
	ClientLastName nvarchar(50),
	ClientSuffixName nvarchar(10),
	ClientBirthDate datetime,
	ClientRaceCode nvarchar(1),
	ClientRaceText nvarchar(40),
	ClientGenderCode nvarchar(1),
	ClientGenderText nvarchar(7),
	ClientJuvenileIndicator nvarchar(10)
	);
GO	




--STEP 3-- run bulk inserts

BULK INSERT  tblDetention
  FROM '\\stncar\d$\Bookings\DetentionExtractDetention.txt' 
  WITH
     (
        FIELDTERMINATOR ='","',
        ROWTERMINATOR ='"\n"',
        FirstRow=2,
		ERRORFILE='\\stncar\d$\Bookings\detention_errors.txt' ,
		MAXERRORS=20
     );



BULK INSERT  tblCharge
  FROM '\\stncar\d$\Bookings\DetentionExtractDetentionCharge.txt' 
  WITH
     (
        FIELDTERMINATOR ='","',
        ROWTERMINATOR ='"\n"',
        FirstRow=2,
		ERRORFILE='\\stncar\d$\Bookings\charge_errors.txt' ,
		MAXERRORS=20
     );



BULK INSERT  tblCourtCase
  FROM '\\stncar\d$\Bookings\DetentionExtractDetentionCourtCase.txt' 
  WITH
     (
        FIELDTERMINATOR ='","',
        ROWTERMINATOR ='"\n"',
        FirstRow=2,
		ERRORFILE='\\stncar\d$\Bookings\courtcase_errors.txt' ,
		MAXERRORS=20
     );




BULK INSERT  tblOffense
  FROM '\\stncar\d$\Bookings\DetentionExtractDetentionOffense.txt' 
  WITH
     (
        FIELDTERMINATOR ='","',
        ROWTERMINATOR ='"\n"',
        FirstRow=2,
		ERRORFILE='\\stncar\d$\Bookings\offense_errors.txt' ,
		MAXERRORS=20
     );



BULK INSERT  tblClient
  FROM '\\stncar\d$\Bookings\DetentionExtractFacilityClient.txt' 
  WITH
     (
        FIELDTERMINATOR ='","',
        ROWTERMINATOR ='"\n"',
        FirstRow=2,
		ERRORFILE='\\stncar\d$\Bookings\client_errors.txt' ,
		MAXERRORS=20
     );


--STEP 4
--check record counts against text files; beware there might be blank rows in text files

select count(*) as OffenseCount
from tbloffense

select count(*) as CourtCaseCount
from tblCourtCase

select count(*) as ClientCount
from tblClient


select count(*) as ChargeCount
from tblCharge

select count(*) as DetentionCount
from tblDetention


--STEP 5
--run some cleanup for stray commas and leading/trailing spaces

update tblclient set clientfirstname=ltrim(replace(clientfirstname,',', '')) where  clientfirstname like '%,%'
update tblclient set clientlastname=ltrim(replace(clientlastname,',', '')) where  clientlastname like '%,%'
update tblclient set clientmiddlename=ltrim(replace(clientmiddlename,',', '')) where  clientmiddlename like '%,%'
update tblclient set clientsuffixname=ltrim(replace(clientsuffixname,',', '')) where  clientsuffixname like '%,%'

update tblclient set detentionfacilityoriidentifier=ltrim(detentionfacilityoriidentifier)
update tblcharge set detentionoffensefacilityoriidentifier=ltrim(detentionoffensefacilityoriidentifier)
update tblcourtcase set detentionoffensefacilityoriidentifier=ltrim(detentionoffensefacilityoriidentifier)
update tbldetention set detentionfacilityoriidentifier=ltrim(detentionfacilityoriidentifier)
update tbloffense set detentionoffensefacilityoriidentifier=ltrim(detentionoffensefacilityoriidentifier)

update tblclient set detentionfacilityoriidentifier=rtrim(detentionfacilityoriidentifier)
update tblcharge set detentionoffensefacilityoriidentifier=rtrim(detentionoffensefacilityoriidentifier)
update tblcourtcase set detentionoffensefacilityoriidentifier=rtrim(detentionoffensefacilityoriidentifier)
update tbldetention set detentionfacilityoriidentifier=rtrim(detentionfacilityoriidentifier)
update tbloffense set detentionoffensefacilityoriidentifier=rtrim(detentionoffensefacilityoriidentifier)


update tblcharge set DETNEXTRDETENTIONID = ltrim(DETNEXTRDETENTIONID)
update tblcharge set DETNEXTRDETENTIONID = rtrim(DETNEXTRDETENTIONID)


update tblclient set DetentionFacilityClientIdentifier = ltrim(DetentionFacilityClientIdentifier)
update tblclient set DetentionFacilityClientIdentifier = rtrim(DetentionFacilityClientIdentifier)
update tblclient set detentionfacilityclientnumber = ltrim(detentionfacilityclientnumber)
update tblclient set detentionfacilityclientnumber = rtrim(detentionfacilityclientnumber)
update tblclient set clientgendertext=ltrim(clientgendertext)
update tblclient set clientgendertext=rtrim(clientgendertext)

update tblcourtcase set DETNEXTRDETENTIONID=ltrim(DETNEXTRDETENTIONID)
update tblcourtcase set DETNEXTRDETENTIONID=rtrim(DETNEXTRDETENTIONID)

update tbldetention set DETNEXTRDETENTIONID=ltrim(DETNEXTRDETENTIONID)
update tbldetention set DETNEXTRDETENTIONID=rtrim(DETNEXTRDETENTIONID)



--Step 6: merge the old data into the new data

insert into tblDetention (DetentionFacilityClientNumber, DetnextrdetentionID, detentionfacilityORIIdentifier, detentionfacilityORIName, detentionfacilityRegisterIdentifier,
DetentionHoldReasonCode, detentionHoldReasonText, DetentionStartDateTime, DetentionEndDateTime, DetentionEndReasonCode,
DetentionEndReasonText, DetentionControllingAgencyORIidentifier, DetentionControllingAgencyORIName, DetentionTypeCode)
select DetentionFacilityClientNumber, DetnextrdetentionID, detentionfacilityORIIdentifier, detentionfacilityORIName, detentionfacilityRegisterIdentifier,
DetentionHoldReasonCode, detentionHoldReasonText, DetentionStartDateTime, DetentionEndDateTime, DetentionEndReasonCode,
DetentionEndReasonText, DetentionControllingAgencyORIidentifier, DetentionControllingAgencyORIName, DetentionTypeCode
from tbldetention_olddata

insert into tblClient(DetentionFacilityORIIdentifier, DetentionFacilityClientIdentifier, DetentionFacilityClientNumber,
ClientFirstName, ClientMiddleName, ClientLastName, ClientSuffixName, ClientBirthDate, ClientRaceCode, ClientRaceText,
ClientGenderCode)
select DetentionOffenseFacilityORIIdentifier, DetentionFacilityClientIdentifier, DetentionFacilityClientNumber,
ClientFirstName, ClientMiddleName, ClientLastName, ClientSuffixName, ClientBirthDate, ClientRaceCode, ClientRaceText,
ClientGenderCode
from tblclient_olddata

insert into tblCourtCase(DetnextrdetentionID, DetentionOFfenseFacilityORIIdentifier, DetentionOffenseFacilityRegisterIdentifier,
DetentionCourtCaseIdentifier)
select DetnextrdetentionID, DetentionOFfenseFacilityORIIdentifier, DetentionOffenseFacilityRegisterIdentifier,
left(DetentionCourtCaseIdentifier,50)
from tblcourtcase_olddata

insert into tbloffense(DetnextrdetentionID, DetentionOFfenseFacilityORIIdentifier, DetentionOffenseFacilityRegisterIdentifier,
DetentionCourtCaseIdentifier, DetentionOFfenseSequenceNumber, DetentionOFfenseStatuteChapterCode, DetentionOFfenseStatuteSectionCode,
 DetentionOFfenseSTatuteSequenceCode, DetentionOFfenseMOCcode, DetentionOffenseText)
select DetnextrdetentionID, DetentionOFfenseFacilityORIIdentifier, DetentionOffenseFacilityRegisterIdentifier,
DetentionCourtCaseIdentifier, cast(DetentionOFfenseSequenceNumber as char), DetentionOFfenseStatuteChapterCode, DetentionOFfenseStatuteSectionCode,
 DetentionOFfenseSTatuteSequenceCode, DetentionOFfenseMOCcode, DetentionOffenseText
from tbloffense_olddata


---Step 7: create indexes

CREATE NONCLUSTERED INDEX [idxClientID] ON [dbo].[tblClient]
(
	[DetentionFacilityClientNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idxClientLastName] ON [dbo].[tblClient]
(
	[ClientLastName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idxClientFirstName] ON [dbo].[tblClient]
(
	[ClientFirstName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



CREATE NONCLUSTERED INDEX [idxCourtCaseDetentionID] ON [dbo].[tblCourtCase]
(
	[DetNextrDetentionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idxDetentionID] ON [dbo].[tblDetention]
(
	[DetNextrDetentionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


CREATE NONCLUSTERED INDEX [idxDetClientID] ON [dbo].[tblDetention]
(
	[DetentionFacilityClientNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO




CREATE NONCLUSTERED INDEX [idxOffenseDetentionID] ON [dbo].[tblOffense]
(
	[DetNextrDetentionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



--STEP 8 -- these were some data cleanup I did, but I think most of the problems were in the older data

update tbldetention set detentionholdreasontext=rtrim(detentionholdreasoncode) where detentionholdreasontext is null and detentionholdreasoncode is not null

update tbldetention set detentionendreasontext=detentionendreasoncode where detentionendreasontext is null and detentionendreasoncode='###'

update tbldetention set detentionendreasontext=lend.endreason
from tbldetention, lend
where tbldetention.detentionendreasoncode=lend.endcode
and detentionendreasontext is null and detentionendreasoncode<>''

update tbldetention set detentionenddatetime=null where year(detentionenddatetime)=1899

update tbldetention set detentioncontrollingagencyoriname=lagency.agency
from tbldetention, lagency
where rtrim(tbldetention.detentioncontrollingagencyoriidentifier)=rtrim(lagency.agencyID)
and detentioncontrollingagencyoriname is null


update tbldetention set detentioncontrollingagencyoriname='OTHER STATE' where detentioncontrollingagencyoriidentifier='OTHSTATE' and 
detentioncontrollingagencyoriname is null

update tbldetention set detentioncontrollingagencyoriname='OUT OF MNNESOTA' where detentioncontrollingagencyoriidentifier='OUTOFMINN' and 
detentioncontrollingagencyoriname is null

update tbldetention set detentioncontrollingagencyoriname='OTHER FEDERAL' where detentioncontrollingagencyoriidentifier='OTHFEDERL' and 
detentioncontrollingagencyoriname is null

update tbldetention set detentioncontrollingagencyoriname='OTHER COUNTRY' where detentioncontrollingagencyoriidentifier='OTHCNTRY' and 
detentioncontrollingagencyoriname is null

update tbldetention set detentioncontrollingagencyoriname='OTHER JURISDICTION' where detentioncontrollingagencyoriidentifier='OTHER JUR' and 
detentioncontrollingagencyoriname is null


update tbldetention set detentioncontrollingagencyoriname=detentioncontrollingagencyoriidentifier
WHERE detentioncontrollingagencyoriname is null AND detentioncontrollingagencyoriidentifier<>''


--Step 9 -- this creates flat table for Uniquery; need to put this on stnewsdb1 for Uniquery to access it
--note that I'm renaming fields here -- that's necessary cause Uniquery can't handle these long field names
--not including records where lasname is null because those are juvenile records where we don't have names

SELECT        dbo.tblClient.DetentionFacilityClientNumber as FacilityClientNumber, dbo.tblClient.ClientFirstName, dbo.tblClient.ClientMiddleName,
 dbo.tblClient.ClientLastName, dbo.tblClient.ClientSuffixName, dbo.tblClient.ClientBirthDate, 
                         dbo.tblClient.ClientRaceText, dbo.tblClient.ClientGenderCode, 
						 dbo.tblDetention.DetentionStartDateTime as StartDateTime, dbo.tblDetention.DetentionEndDateTime as EndDateTime, 
						 dbo.tblDetention.detentionfacilityORIName as facilityORIName, 
						  dbo.tblDetention.detentionHoldReasonText as HoldReasonText, dbo.tblDetention.DetentionEndReasonText as EndReasonText, 
						  dbo.tblOffense.DetentionOffenseSequenceNumber as OffenseSequenceNumber, dbo.tblOffense.DetentionOffenseStatuteChapterCode as OffenseStatuteChapterCode, 
                         dbo.tblOffense.DetentionOffenseStatuteSectionCode as OffenseStatuteSectionCode, dbo.tblOffense.DetentionOffenseStatuteSequenceCode as OffenseStatuteSequenceCode, 
						 dbo.tblOffense.DetentionOffenseMOCcode as OffenseMOCcode, dbo.tblOffense.DetentionOffenseText as OffenseText, 
                         dbo.tblDetention.DetentionControllingAgencyORIName as controllingAgencyORIName, dbo.Ldettype.DetDesc, dbo.tblCourtCase.DetentionCourtCaseIdentifier as CourtCaseIdentifier,
						  dbo.tblCourtCase.DetentionCourtCaseSentenceStartDate as CourtCaseSentenceStartDate
 INTO uq_bookings
						  
FROM            dbo.tblDetention INNER JOIN
                         dbo.tblClient ON dbo.tblDetention.DetentionFacilityClientNumber = dbo.tblClient.DetentionFacilityClientNumber INNER JOIN
                         dbo.tblOffense ON dbo.tblDetention.DetnextrdetentionID = dbo.tblOffense.DETNEXTRDetentionID LEFT OUTER JOIN
                         dbo.tblCourtCase ON dbo.tblOffense.DETNEXTRDetentionID = dbo.tblCourtCase.DETNEXTRDetentionID LEFT OUTER JOIN
                         dbo.Ldettype ON dbo.tblDetention.DetentionTypeCode = dbo.Ldettype.DetCode
WHERE        (dbo.tblClient.ClientLastName IS NOT NULL)


--Step 10 -- get rid of old tables; leave the relational tables on stnewsdb3

--Other notes: both stnewsdb1 and stnewsdb3 have lookup tables that are no longer needed; could purge those in the future
--also there are a series of tables ending with "raw" on stnewsdb3 that are the table structures Glen used; could purge in the future