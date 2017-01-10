USE [db_news_sandbox1]
GO

/****** Object:  Table [dbo].[deaths_main]    Script Date: 3/31/2016 3:09:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[deaths_main](
	[STATEID] [varchar](25) NULL,
	[FIRSTNAME] [varchar](50) NULL,
	[MIDDLENAME] [varchar](50) NULL,
	[LASTNAME] [varchar](50) NULL,
	[MAIDENNAME] [varchar](50) NULL,
	[SUFFIX] [varchar](10) NULL,
	[BIRTHDATE] [datetime] NULL,
	[DEATHDATE] [datetime] NULL,
	[GENDER] [varchar](1) NULL,
	[RACE] [varchar](50) NULL,
	[HISPANICETHNICITY] [varchar](50) NULL,
	[AGE_TYPE] [varchar](5) NULL,
	[AGEYEARS] [smallint] NULL,
	[AGEMONTHS] [smallint] NULL,
	[AGEDAYS] [smallint] NULL,
	[AGEHOURS] [smallint] NULL,
	[AGEMINUTES] [smallint] NULL,
	[BIRTHCOUNTRY] [varchar](50) NULL,
	[BIRTHSTATE] [varchar](50) NULL,
	[BIRTHCITY] [varchar](50) NULL,
	[NURSHOME] [varchar](5) NULL,
	[RESFACILITY] [varchar](255) NULL,
	[RESADDRESS] [varchar](255) NULL,
	[RESCOUNTRY] [varchar](50) NULL,
	[RESSTATE] [varchar](50) NULL,
	[RESCOUNTY] [varchar](50) NULL,
	[RESCITY] [varchar](50) NULL,
	[ZIP] [varchar](10) NULL,
	[ARMEDFORCES] [varchar](10) NULL,
	[YEARSEDUCATION] [varchar](150) NULL,
	[OCCUPATION] [varchar](150) NULL,
	[INDUSTRY] [varchar](150) NULL,
	[MARITALSTATUS] [varchar](50) NULL,
	[SPOUSEFIRST] [varchar](50) NULL,
	[SPOUSEMIDDLE] [varchar](50) NULL,
	[SPOUSELAST] [varchar](50) NULL,
	[FATHERFIRST] [varchar](50) NULL,
	[FATHERMIDDLE] [varchar](50) NULL,
	[FATHERLAST] [varchar](50) NULL,
	[FATHERSUFFIX] [varchar](10) NULL,
	[MOTHERFIRST] [varchar](50) NULL,
	[MOTHERMIDDLE] [varchar](50) NULL,
	[MOTHERMAIDEN] [varchar](50) NULL,
	[PLACETYPE] [varchar](150) NULL,
	[PLACEOTHER] [varchar](200) NULL,
	[FACILITY] [varchar](200) NULL,
	[FACILITYOTHER] [varchar](200) NULL,
	[DEATHADDRESS] [varchar](255) NULL,
	[DEATHCOUNTRY] [varchar](50) NULL,
	[DEATHSTATE] [varchar](50) NULL,
	[DEATHCITY] [varchar](50) NULL,
	[DEATHZIP] [varchar](10) NULL,
	[DEATHCOUNTY] [varchar](50) NULL,
	[CAUSEA] [varchar](255) NULL,
	[CAUSEB] [varchar](255) NULL,
	[CAUSEC] [varchar](255) NULL,
	[CAUSED] [varchar](255) NULL,
	[CAUSEOTHER] [varchar](255) NULL,
	[MANNERDEATH] [varchar](255) NULL,
	[INJURY_DATE] [datetime] NULL,
	[INJURYPLACE] [varchar](255) NULL,
	[INJURYWORK] [varchar](1) NULL,
	[INJURYADDRESS] [varchar](100) NULL,
	[INJURYSTATE] [varchar](50) NULL,
	[INJURYCOUNTY] [varchar](50) NULL,
	[INJURYCOUNTRY] [varchar](50) NULL,
	[INJURYCITY] [varchar](50) NULL,
	[INJURYZIP] [varchar](10) NULL,
	[INJURYDESC] [varchar](255) NULL,
	[IMPORTDATE] [datetime] NULL,
	[DEATHYEAR] [varchar](4) NULL,
	[SOURCECODE] [varchar](50) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

