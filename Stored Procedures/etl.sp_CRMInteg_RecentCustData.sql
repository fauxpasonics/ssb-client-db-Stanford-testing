SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [etl].[sp_CRMInteg_RecentCustData]
AS

TRUNCATE TABLE etl.CRMProcess_RecentCustData

DECLARE @Client VARCHAR(50)
SET @Client = 'Stanford'

SELECT x.dimcustomerid, MAX(x.maxtransdate) maxtransdate, x.team
INTO #tmpTicketSales
	FROM (
		--Ticketing
		SELECT dc.DimCustomerID, MAX(tk.I_Date) MaxTransDate , @Client Team
		--Select * 
		FROM dbo.TK_ODET tk WITH(NOLOCK)	
		JOIN dbo.DimCustomer dc WITH(NOLOCK) ON tk.Customer = dc.SSID AND Sourcesystem = 'Stanford_TI'	
		WHERE tk.I_Date >= DATEADD(YEAR, -3, GETDATE())
		GROUP BY dc.[DimCustomerId]

		UNION ALL 

		--Adobe
		SELECT dc.DimCustomerID, MAX(dl.EventDate) MaxTransDate , @Client Team
		--Select * 
		FROM [ods].[Adobe_DeliveryLog] dl WITH(NOLOCK)	
		JOIN  dbo.DimCustomer dc WITH(NOLOCK) ON dl.AccountFK = dc.SSID AND Sourcesystem = 'Adobe'	
		WHERE dl.EventDate >= DATEADD(DAY, -90, GETDATE())
		GROUP BY dc.[DimCustomerId]

		UNION ALL 

		--Sponsor Accounts (added 5/8/2017 AMEITIN)
		SELECT dc.DimCustomerID, MAX(org.Export_Datetime) MaxTransDate, @Client Team
		--Select * 
		FROM dbo.PD_ORG org WITH(NOLOCK)	
		JOIN  dbo.DimCustomer dc WITH(NOLOCK) ON org.ORG = dc.SSID AND Sourcesystem = 'Stanford_TI'	
		WHERE org.ORG_TYPE LIKE 'SP%'
		GROUP BY dc.[DimCustomerId]


		) x
		GROUP BY x.dimcustomerid, x.team



INSERT INTO etl.CRMProcess_RecentCustData (dimcustomerid, SSID, MaxTransDate, Team)
SELECT a.dimcustomerid, SSID, [MaxTransDate], Team FROM [#tmpTicketSales] a 
INNER JOIN dbo.[vwDimCustomer_ModAcctId] b ON [b].[DimCustomerId] = [a].[DimCustomerId]




GO
