SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [rpt].[vw_Adobe_Recipient]
AS	

SELECT  dcb.SSB_CRMSYSTEM_CONTACT_ID
		,recipient.*
FROM    [ods].[Adobe_Recipient] recipient  WITH(NOLOCK)  
		LEFT JOIN  dbo.dimcustomerssbid dcb WITH(NOLOCK) ON  dcb.sourcesystem = 'Adobe' AND recipient.PrimaryKey = dcb.SSID  --update source system based on client DimCustomer



		



GO
