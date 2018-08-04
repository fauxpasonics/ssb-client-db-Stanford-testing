SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [etl].[vwCRMProcess_SeasonTicketHolders]
AS

SELECT DISTINCT CAST(dc.SSID AS VARCHAR(50)) SSID
, CAST(s.SeasonYear AS VARCHAR(50)) SeasonYear
, CAST(s.SeasonYear AS VARCHAR(50)) SeasonYr

--select top 100 * 
 FROM [dbo].[FactTicketSales] fts (NOLOCK)
	   INNER JOIN dbo.DimTicketCustomer dtc (NOLOCK) on dtc.DimTicketCustomerId = fts.DimTicketCustomerId
       INNER JOIN dbo.DimCustomer dc (NOLOCK) on dtc.CustomerId = dc.SSID and Sourcesystem = 'Stanford_TI'
	   INNER JOIN [dbo].[DimSeason] s (NOLOCK)  ON fts.DimSeasonId =s.DimSeasonId 
       INNER JOIN [dbo].[DimItem] i  (NOLOCK)  ON fts.DimSeasonId =s.DimSeasonId and fts.DimItemId = i.DimItemId  
WHERE i.ItemClass = 'ST'



GO
