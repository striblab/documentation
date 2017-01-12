USE [docpay]
GO

/****** Object:  Table [dbo].[ownership]    Script Date: 06/29/2015 09:05:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ownership_2014](

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
	[phystype] [nvarchar](50) NULL,
	[specialty] [nvarchar](300) NULL,
	[tranid] [nvarchar](38) NULL,
	[progyr] [char](4) NULL,	
	[AmtInvested] [money] NULL,
	[value] [money] NULL,
	[terms] [nvarchar](500) NULL,	
	[mfgr] [nvarchar](100) NULL,
	[payerid] [nvarchar](38) NULL,		
	[payer] [nvarchar](100) NULL,
	[payerstate] [nvarchar](2) NULL,
	[payercountry] [nvarchar](2) NULL,
	[disputestatus] [nvarchar](3) NULL,
	[interestheld] [nvarchar](50) NULL,
	[pubdate] [datetime] NULL,

	
	
	
)

SET ANSI_PADDING OFF
GO


