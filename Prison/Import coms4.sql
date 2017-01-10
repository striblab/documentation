
CREATE TABLE dbo.Prison_COMS4_Offender (
	OID varchar(50),
	CommName varchar(200),
	LegName varchar(200),
	AuthID varchar(110),
	Sex varchar(50),
	race varchar(50),
	DOB datetime,
	LegStat varchar(50),
	CurrStat varchar(50),
	StatType varchar(50),
	StatDate datetime,
	CurrLoc varchar(255),
	SecurityStat varchar(5),
	FedStateCode varchar(5),
	FedStDate varchar(10),
	FedStLoc varchar(5),
	ISRecSend varchar(50),
	DrvrLicID  varchar(50),
	DrvrLicState  varchar(50),
	StribImportDate datetime,
	LastName varchar(50),
	RestName varchar(50)
		);
GO	


CREATE TABLE dbo.Prison_COMS4_Sentence(
	OID varchar(50),
	SentNo varchar(50),
	AdmitDate varchar(50),
	LegStat varchar(50),
	SentType varchar(50),
	SentAuth varchar(255),
	SentCnty varchar(255),
	SentStat varchar(50),
	GovSent varchar(50),
	MaxYears varchar(50),
	MaxMonths varchar(50),
	MaxDays varchar(50),
	JailCredit varchar(50),
	MaxGT varchar(50),
	GTLost varchar(50),
	EffSentDate varchar(50),
	ExpDate varchar(50),
	SupRelDate varchar(50),
	CondRelDate varchar(50),
	CondRelYears varchar(50),
	CtrlDate varchar(50),
	OffnCode varchar(50),
	OffnModifier varchar(50),
	OffnStatute varchar(50),
	OffnCount varchar(50),
	Filler varchar(50),
	StribImportDate datetime
			);
GO	





BULK INSERT  Prison_COMS4_Sentence
  FROM '\\stncar\d$\Prison\Historical_data\tables\Sentence.txt' 
  WITH
     (
        FORMATFILE = '\\stncar\d$\Prison\Historical_data\format\Sentence_com4.fmt' ,
        FirstRow=1,
		ERRORFILE='\\stncar\d$\prison\Historical_data\coms4_sentence_errors.txt' ,
		MAXERRORS=20
     );

go



BULK INSERT  Prison_COMS4_Offender
  FROM '\\stncar\d$\Prison\Historical_data\tables\Offender.txt' 
  WITH
     (
        FORMATFILE = '\\stncar\d$\Prison\Historical_data\format\Offender.fmt' ,
        FirstRow=1,
		ERRORFILE='\\stncar\d$\prison\Historical_data\coms4_offender_errors.txt' ,
		MAXERRORS=20
     );

go

select top 100 *
from prison_coms4_sentence


CREATE TABLE dbo.Prison_COMS4_StatusLocation (
	StatLoc varchar(50),
	StatLocDesc varchar(255),
	filler varchar(1)
				);
GO	


BULK INSERT  Prison_COMS4_StatusLocation
  FROM '\\stncar\d$\Prison\Historical_data\tables\StatusLocation.txt' 
  WITH
     (
        FORMATFILE = '\\stncar\d$\Prison\Historical_data\format\StatusLocation.fmt' ,
        FirstRow=1,
		ERRORFILE='\\stncar\d$\prison\Historical_data\coms4_StatusLocation_errors.txt' ,
		MAXERRORS=20
     );

go


CREATE TABLE dbo.Prison_COMS4_CodeOffense (
	OffnCdID varchar(50),
	OffnCdDesc varchar(255),
	filler varchar(1)
				);
GO	


BULK INSERT  Prison_COMS4_CodeOffense
  FROM '\\stncar\d$\Prison\Historical_data\tables\CodeOffense.txt' 
  WITH
     (
        FORMATFILE = '\\stncar\d$\Prison\Historical_data\format\CodeOffense.fmt' ,
        FirstRow=1,
		ERRORFILE='\\stncar\d$\prison\Historical_data\coms4_CodeOffense_errors.txt' ,
		MAXERRORS=20
     );

go


CREATE TABLE dbo.Prison_COMS4_STSStatus (
	OffStat varchar(50),
	OffStatDesc varchar(255),
	filler varchar(1)
				);
GO	

BULK INSERT  Prison_COMS4_STSStatus
  FROM '\\stncar\d$\Prison\Historical_data\tables\STSStatus.txt' 
  WITH
     (
        FORMATFILE = '\\stncar\d$\Prison\Historical_data\format\STSStatus.fmt' ,
        FirstRow=1,
		ERRORFILE='\\stncar\d$\prison\Historical_data\coms4_STSStatus_errors.txt' ,
		MAXERRORS=20
     );

go

update prison_coms4_sentence set sentencestatus='ACTIVE' where sentstat='1'
update prison_coms4_sentence set sentencestatus='INACTIVE' where sentstat='2'
update prison_coms4_sentence set sentencestatus='CLOSED' where sentstat='3'
update prison_coms4_sentence set sentencestatus='VIOLATION' where sentstat='4'
update prison_coms4_sentence set sentencestatus='REVOKED' where sentstat='5'




select *
from solitary_1

select top 100 *
from prison_coms4_offender
where oid like '246%'


update prison_coms4_offender set currentstatus=rtrim(offstatdesc)
from prison_coms4_offender, prison_coms4_stsstatus
where prison_coms4_offender.currstat = prison_coms4_stsstatus.offstat

select top 100 *
from prison_coms4_offender
where currentlocation is null

update prison_coms4_offender set currentlocation=rtrim(statlocdesc)
from prison_coms4_offender, prison_coms4_statuslocation
where prison_coms4_offender.currloc = prison_coms4_statuslocation.statloc



update prison_coms4_offender set lastname= rtrim(left(commname, charindex(',', commname)-1)) where commname like '%,%'
go
update prison_coms4_offender set restname= ltrim(substring(commname, charindex(',', commname)+1, 100)) where commname like '%,%'


update prison_coms4_offender set lastname=LTRIM(UPPER(LASTNAME))
update prison_coms4_offender set RESTNAME=LTRIM(UPPER(RESTNAME))

select top 100 oid, lastname, restname, sex, cast(substring(dob,5,2)+'/'+substring(dob,7,2)+'/'+left(dob,4) as datetime) as DateOfBirth, CurrentStatus, CurrentLocation,
cast(substring(statdate,5,2)+'/'+substring(statdate,7,2)+'/'+left(statdate,4) as datetime) as StatusDate
from prison_coms4_offender 


select top 100 *
from prison_coms4_sentence

update prison_coms4_sentence set offense=offncddesc
from prison_coms4_sentence, prison_coms4_codeoffense
where rtrim(prison_coms4_sentence.offncode)=rtrim(prison_coms4_codeoffense.offncdid)

select *
from prison_coms4_sentence
where offense is null

select *
from prison_coms4_codeoffense

select oid, cast(substring(admitdate,5,2)+'/'+substring(admitdate,7,2)+'/'+left(admitdate,4) as datetime) as AdmitDatedt,
maxyears, maxmonths, maxdays, cast(substring(supreldate,5,2)+'/'+substring(supreldate,7,2)+'/'+left(supreldate,4) as datetime) as SupervisoryReleaseDate






select top 100 *
from prison_coms4_offender

update prison_coms4_offender set dob = cast(substring(dobtxt,5,2)+'/'+substring(dobtxt,7,2)+'/'+left(dobtxt,4) as datetime)

update prison_coms4_offender set statdate = cast(substring(statdatetxt,5,2)+'/'+substring(statdatetxt,7,2)+'/'+left(statdatetxt,4) as datetime)

update prison_coms4_offender set fedstdate = cast(substring(fedstdatetxt,5,2)+'/'+substring(fedstdatetxt,7,2)+'/'+left(fedstdatetxt,4) as datetime)

select top 100 *
from prison_offender

select stattype, count(*)
from prison_coms4_offender
group by stattype
order by 1

select stattype, count(*)
from prison_offender
group by stattype
order by 1

update prison_coms4_authoritylkup set authidcode=ltrim(authidcode)

update prison_coms4_authoritylkup set authidcode=rtrim(authidcode)

select top 100 *
from prison_coms4_offender

update prison_coms4_tsalkup set stattypecode=ltrim(stattypecode)

update prison_coms4_tsalkup set stattypecode=rtrim(stattypecode)

update prison_coms4_offender set prison_coms4_offender.stattype= prison_coms4_tsalkup.stattypedesc
from prison_coms4_offender, prison_coms4_tsalkup
where prison_coms4_offender.stattypecode=prison_coms4_tsalkup.stattypecode

update prison_coms4_offender set prison_coms4_offender.authid= prison_coms4_authoritylkup.authiddesc
from prison_coms4_offender, prison_coms4_authoritylkup
where prison_coms4_offender.authidcode=prison_coms4_authoritylkup.authidcode


select authid, count(*)
from prison_coms4_offender
group by authid
order by 2 desc

update prison_coms4_offender set authid='DOC' where authid like 'DOC%'



update prison_coms4_offender set authid=replace(authid, '1', '') where right(authid,1)='1'
update prison_coms4_offender set authid=rtrim(authid)



select stattype, count(*)
from prison_coms4_offender
group by stattype
order by 2 desc

update prison_coms4_offender set stattype=replace(stattype, '1', '') where right(stattype,1)='1'
update prison_coms4_offender set stattype=rtrim(stattype)


select top 100 *
from prison_coms4_sentence

update prison_coms4_sentence set admitdate = substring(admitdatetxt,5,2)+'/'+substring(admitdatetxt,7,2)+'/'+left(admitdatetxt,4)
update prison_coms4_sentence set expdate = substring(expdatetxt,5,2)+'/'+substring(expdatetxt,7,2)+'/'+left(expdatetxt,4)
update prison_coms4_sentence set condrel = substring(condreldatetxt,5,2)+'/'+substring(condreldatetxt,7,2)+'/'+left(condreldatetxt,4)
update prison_coms4_sentence set effsentdate = cast(substring(effsentdatetxt,5,2)+'/'+substring(effsentdatetxt,7,2)+'/'+left(effsentdatetxt,4) as datetime)

update prison_coms4_sentence set reldate = substring(supreldatetxt,5,2)+'/'+substring(supreldatetxt,7,2)+'/'+left(supreldatetxt,4)

update prison_coms4_sentence set prison_coms4_sentence.sentauth= prison_coms4_authoritylkup.authiddesc
from prison_coms4_sentence, prison_coms4_authoritylkup
where prison_coms4_sentence.sentauthtxt=prison_coms4_authoritylkup.authidcode


create table dbo.prison_coms4_history(
	OID varchar(50),
	stat_datetxt varchar(8),
	stattime varchar(8),
	currstattxt varchar(2),
	stataction varchar(2),
	authidtxt varchar(2),
	currloctxt varchar(3),
	filler varchar(1),
	stat_date datetime,
	currstat varchar(50),
	authid varchar(50),
	currloc varchar(100)
			);
GO	




BULK INSERT  Prison_COMS4_History
  FROM '\\stncar\d$\Prison\Historical_data\tables\History.txt' 
  WITH
     (
        FORMATFILE = '\\stncar\d$\Prison\Historical_data\format\History.fmt' ,
        FirstRow=1,
		ERRORFILE='\\stncar\d$\prison\Historical_data\coms4_history_errors.txt' ,
		MAXERRORS=20
     );

go

select top 100 *
from prison_coms4_history


update prison_coms4_history set stat_date = cast(substring(stat_datetxt,5,2)+'/'+substring(stat_datetxt,7,2)+'/'+left(stat_datetxt,4) as datetime)


update prison_coms4_history set prison_coms4_history.authid= prison_coms4_authoritylkup.authiddesc
from prison_coms4_history, prison_coms4_authoritylkup
where prison_coms4_history.authidtxt=prison_coms4_authoritylkup.authidcode


select *
from prison_coms4_stsstatus


select currstattxt, count(*)
from prison_coms4_history
group by currstattxt

update prison_coms4_history set currstat= prison_coms4_stsstatus.offstatdesc
from prison_coms4_history, prison_coms4_stsstatus
where prison_coms4_history.currstattxt=prison_coms4_stsstatus.offstat


update prison_coms4_history set currloc=rtrim(statlocdesc)
from prison_coms4_history, prison_coms4_statuslocation
where prison_coms4_history.currloctxt = prison_coms4_statuslocation.statloc

select top 10 *
from prison_history

select top 10 *
from prison_coms4_history



create table dbo.prison_coms4_alias(
	OID varchar(50),
	aliasname varchar(60),
	nametype varchar(1),
	dobtxt varchar(8),
	sex varchar(1),
	race varchar(1),
	filler varchar(1),
	dob datetime
			);
GO	


BULK INSERT  Prison_COMS4_alias
  FROM '\\stncar\d$\Prison\Historical_data\tables\alias.txt' 
  WITH
     (
        FORMATFILE = '\\stncar\d$\Prison\Historical_data\format\alias.fmt' ,
        FirstRow=1,
		ERRORFILE='\\stncar\d$\prison\Historical_data\coms4_alias_errors.txt' ,
		MAXERRORS=20
     );

go

select top 100 *
from prison_coms4_alias


update prison_coms4_alias set dob = cast(substring(dobtxt,5,2)+'/'+substring(dobtxt,7,2)+'/'+left(dobtxt,4) as datetime)

select *
from prison_coms4_alias
where oid not in
(select oid from prison_alias)

select top 100 *
from prison_offender

insert into prison_offender (oid, commname, legname, authid, sex, dob, legstat, currstat, stattype, statdate, currlocation, isrecsend, drvrlicid, drvrlicstate, lastname, restname, stribImportDate, [source])
select oid, commname, legname, authid, sex, dob, legstat, currentstatus, stattype, statdate, currentlocation, isrecsend, drvrlicid, drvrlicstate, lastname, restname, getdate() as StribImportDate, 'COMS4' as source
from prison_coms4_offender
where oid not in
(select oid from prison_offender)

update prison_offender set [source]='COMS5'

select currentstatus, count(*)
from prison_coms4_offender
group by currentstatus
order by 1

select stattype, count(*)
from prison_coms4_offender
group by stattype
order by 1

select count(*)
from prison_coms4_offender

select count(*)
from prison_offender



update prison_alias set [source]='COMS5'


insert into prison_alias(oid, aliasname, nametype, dob, sex, stribimportdate, [source])
select oid, aliasname, nametype, dob, sex, getdate() as stribimportdate, 'COMS4' as source
from prison_coms4_alias
where oid not in
(select oid from prison_alias)

select top 10 prison_history.*
from prison_history inner join prison_coms4_history on prison_history.oid=prison_coms4_history.oid

select *
from prison_offender
where oid not in
(select oid from prison_sentence)

select *
from prison_sentence
where oid='100012'

update prison_sentence set [source]='COMS5'
update prison_history set [source]='COMS5'

select senttype, count(*)
from prison_coms4_sentence
group by senttype


insert into prison_sentence(oid, sentno, admitdate, legstat,  sentauth, sentstat, governing, maxyears, maxmonths, maxdays, jailcredit, effsentdate,
expdate, reldate, condrel, activeoffense, stribimportdate, [source])
select oid, sentno, admitdate, legstat,  sentauth, sentstat, govsent, maxyears, maxmonths, maxdays, jailcredit, effsentdate, expdate,
reldate, condrel, offense, getdate() as stribimportdate, 'COMS4' as source
from prison_coms4_sentence
where oid not in
(select oid from prison_sentence)

insert into prison_history(oid, statdate, currstat, authid, currloc, stribimportdate, [source])
select oid, stat_date, currstat, authid, currloc, getdate() as stribimportdate, 'COMS4' as source
from prison_coms4_history
where oid not in
(select oid from prison_history)

select *
from prison_history
where oid='211920'


select  a.oid, a.lastname, a.restname, a.dob, a.currstat, a.source, b.sentno, b.activeoffense, b.effsentdate, b.reldate
from prison_offender a left join prison_sentence b on a.oid=b.oid
where activeoffense is null


select *
from prison_history
where oid='209516'


select count(*)
from prison_offender

select oid, max(statdate)
from prison_history
group by oid

select *
from prison_offender
where oid='246909'


select *
from prison_offender
where currstat is null

select *
from prison_history
where oid='214115'

update prison_offender set currstat='SUPV REL' where oid='214115'

select top 100 *
from prison_offender




select oid into temp_no_obgl
from prison_offender
where oid not in
(select oid from prison_obligation)		

update prison_offender set no_obligation='y' 
from prison_offender, temp_no_obgl
where prison_offender.oid=temp_no_obgl.oid

select governing, count(*)
from prison_sentence
where no_obligation='y'
group by governing


select [source], count(*)
from prison_offender
where no_obligation='y'
group by [source]




select a.oid, a.lastname, a.restname, a.sex, a.dob, a.currstat, a.stattype, a.statdate, a.currlocation, a.authid, 
b.obligationidentifier, b.statustypetext, b.admitdate, b.expdate, b.reldate, b.overallmndocoffensecategorytype as overalloffense,
b.activemndocoffensecategorytype as activeoffense, b.source into prison_uniquery
from prison_offender a inner join prison_obligation b on a.oid=b.oid


insert into prison_uniquery(oid, lastname, restname, sex, dob, currstat, stattype, statdate, currlocation, authid, obligationidentifier,
statustypetext, admitdate, expdate, reldate, overalloffense, activeoffense, [source])
select a.oid, a.lastname, a.restname, a.sex, a.dob, a.currstat, a.stattype, a.statdate, a.currlocation, a.authid, 
b.sentno, b.senttype, b.admitdate, b.expdate, b.reldate, b.activeoffense as overalloffense, '' as activeoffense, b.source
from prison_offender a inner join prison_sentence b on a.oid=b.oid
where a.no_obligation='y' and b.governing='y'


insert into prison_uniquery(oid, lastname, restname, sex, dob, currstat, stattype, statdate, currlocation, authid, [source])
select distinct a.oid, a.lastname, a.restname, a.sex, a.dob, a.currstat, a.stattype, a.statdate, a.currlocation, a.authid, a.source
from prison_offender a
where oid not in
(select oid from prison_uniquery)

select count(*)
from prison_uniquery

select oid,  count(*)
from prison_uniquery
where [source] is null
group by oid
order by 2 desc

select *
from prison_uniquery
where oid='116376'

select count(*)
from prison_offender

select *
from prison_offender
where oid not in
(select oid from prison_uniquery)

update prison_uniquery set [source]='COMS5' where [source] is null

update prison_obligation set [source]='COMS5'


update prison_offender set currlocation='UNKNOWN' where currlocation='UK' 

select currlocation, count(*)
from prison_offender
group by currlocation

select prison_uniquery.oid, prison_uniquery.lastname, prison_sentence.activeoffense, sentno, governing, prison_sentence.admitdate, prison_sentence.expdate, prison_sentence.reldate
from prison_uniquery inner join prison_sentence on prison_uniquery.oid=prison_sentence.oid
where overalloffense=''

update prison_uniquery set prison_uniquery.overalloffense=prison_sentence.activeoffense, prison_uniquery.admitdate=prison_sentence.admitdate,
prison_uniquery.expdate=prison_sentence.expdate, prison_uniquery.reldate=prison_sentence.reldate
from prison_uniquery, prison_sentence
where prison_uniquery.overalloffense is null and prison_sentence.sentno='01'

update prison_uniquery set prison_uniquery.overalloffense=prison_sentence.activeoffense, prison_uniquery.admitdate=prison_sentence.admitdate,
prison_uniquery.expdate=prison_sentence.expdate, prison_uniquery.reldate=prison_sentence.reldate
from prison_uniquery, prison_sentence
where prison_uniquery.overalloffense='' and prison_sentence.sentno='01'


select top 100 *
from prison_uniquery

select *
from prison_uniquery
where overalloffense='' or overalloffense is null

