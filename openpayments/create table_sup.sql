USE [docpay]
GO

/****** Object:  Table [dbo].[sup]    Script Date: 06/29/2015 09:06:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[sup_2014](
	[physid] [nvarchar](38) NULL,
	[physfname] [nvarchar](20) NULL,
	[physlname] [nvarchar](35) NULL,
	[physAltFname] [nvarchar](20) NULL,
	[physAltLname] [nvarchar](35) NULL,
	[addr1] [nvarchar](55) NULL,
	[addr2] [nvarchar](55) NULL,
	[city] [nvarchar](40) NULL,
	[state] [nvarchar](2) NULL,
	[zip] [nvarchar](10) NULL,
	[country] [nvarchar](100) NULL,
	[province] [nvarchar](20) NULL,
	[spec1] [nvarchar](300) NULL,
	[lic1] [nvarchar](2) NULL,
	[lic2] [nvarchar](2) NULL,
	[lic3] [nvarchar](2) NULL,
	[lic4] [nvarchar](2) NULL,
	[lic5] [nvarchar](2) NULL,
)

