USE [docpay]
GO

/****** Object:  Table [dbo].[general]    Script Date: 06/29/2015 09:01:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[general_2014](
	[reciptype] [nvarchar](50) NULL,
	[hospid] [nvarchar](38) NULL,
	[hospname] [nvarchar](100) NULL,
	[physid] [nvarchar](38) NULL,
	[physfname] [nvarchar](20) NULL,	
	[physmname] [nvarchar](20) NULL,
	[physlname] [nvarchar](35) NULL,
	[physsuffix] [nvarchar](5) NULL,
	[addr1] [nvarchar](55) NULL,
	[addr2] [nvarchar](55) NULL,
	[city] [nvarchar](40) NULL,
	[state] [nvarchar](2) NULL,
	[zip] [nvarchar](50) NULL,
	[country] [nvarchar](100) NULL,
	[province] [nvarchar](20) NULL,
	[postal] [nvarchar](20) NULL,	
	[phystype] [nvarchar](100) NULL,
	[specialty] [nvarchar](300) NULL,
	[lic1] [nvarchar](2) NULL,
	[lic2] [nvarchar](2) NULL,
	[lic3] [nvarchar](2) NULL,
	[lic4] [nvarchar](2) NULL,
	[lic5] [nvarchar](2) NULL,
	[mfgr] [nvarchar](100) NULL,
	[payerid] [nvarchar](38) NULL,
	[payer] [nvarchar](100) NULL,	
	[payerstate] [nvarchar](2) NULL,
	[payercountry] [nvarchar](100) NULL,
	[payment] [money] NULL,
	[paydate] [datetime] NULL,
	[payments] [int] NULL,
	[payform] [nvarchar](100) NULL,
	[paynature] [nvarchar](200) NULL,
	[travelcity] [nvarchar](40) NULL,
	[travelstate] [nvarchar](2) NULL,
	[travelcountry] [nvarchar](100) NULL,
	[physownership] [nvarchar](3) NULL,
	[thirdparty] [nvarchar](50) NULL,
	[thirdname] [nvarchar](50) NULL,
	[charity] [nvarchar](3) NULL,
	[covrecip] [nvarchar](3) NULL,
	[context] [nvarchar](500) NULL,
	[delay] [nvarchar](3) NULL,
	[tranid] [nvarchar](38) NOT NULL,
	[disputestatus] [nvarchar](3) NULL,
	[prodindicator] [nvarchar](50) NULL,
	[assoc1] [nvarchar](100) NULL,
	[assoc2] [nvarchar](100) NULL,
	[assoc3] [nvarchar](100) NULL,
	[assoc4] [nvarchar](100) NULL,
	[assoc5] [nvarchar](100) NULL,
	[ndc1] [nvarchar](12) NULL,
	[ndc2] [nvarchar](12) NULL,
	[ndc3] [nvarchar](12) NULL,
	[ndc4] [nvarchar](12) NULL,
	[ndc5] [nvarchar](12) NULL,
	[market1] [nvarchar](100) NULL,
	[market2] [nvarchar](100) NULL,
	[market3] [nvarchar](100) NULL,
	[market4] [nvarchar](100) NULL,
	[market5] [nvarchar](100) NULL,
	[progyr] [nvarchar](4) NULL,
	[pubdate] [nvarchar](20) NULL,

)



	

	