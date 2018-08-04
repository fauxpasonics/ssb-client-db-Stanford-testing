SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [dbo].[vwCRMLoad_MarketingTransactions]
AS 

SELECT 
DimCustomer.SSB_CRMSYSTEM_CONTACT_ID
,tracking.TrackingDate AS Activity_Date__c
,tracking.URLType +  '' + ':' +  ' ' + delivery.Label AS Subject__c
,tracking.URLType +  ''  + ':' +  ' '  + tracking.URLLabel +  ' ' + Delivery.Label +  ' '  + tracking.SourceURL AS Description__c
,tracking.primarykey primarykey
FROM [ods].[Adobe_TrackingLog] tracking WITH(NOLOCK)
JOIN dbo.vwDimCustomer_ModAcctId DimCustomer WITH (NOLOCK) ON DimCustomer.SourceSystem = 'Adobe' AND tracking.AccountFK = DimCustomer.SSID
JOIN [ods].[Adobe_Delivery] delivery WITH (NOLOCK) ON tracking.DeliveryFK = delivery.PrimaryKey
WHERE 1=1
AND tracking.TrackingDate > (SELECT DATEADD(d, -365,MAX([TrackingDate])) FROM [ods].[Adobe_TrackingLog] WITH (NOLOCK) )
AND URLType = 'Email Click'
AND URLLabel LIKE 'ACCL-%'


UNION ALL 

SELECT 
DimCustomer.SSB_CRMSYSTEM_CONTACT_ID
,tracking.TrackingDate AS Activity_Date__c
,CASE WHEN tracking.URLType = 'Web' THEN 'High Value Page View' END AS Subject__c 
,tracking.URLLabel +  ' ' + tracking.SourceURL AS Description__c
,tracking.primarykey primarykey
FROM [ods].[Adobe_TrackingLog] tracking WITH(NOLOCK)
JOIN dbo.vwDimCustomer_ModAcctId DimCustomer WITH (NOLOCK) ON DimCustomer.SourceSystem = 'Adobe' AND tracking.AccountFK = DimCustomer.SSID
WHERE 1=1
AND tracking.TrackingDate > (SELECT DATEADD(d, -365, MAX([TrackingDate])) FROM [ods].[Adobe_TrackingLog] WITH (NOLOCK) )
AND URLType =  ('Web') 
AND URLLabel LIKE 'ACPV-%' 


UNION ALL

SELECT 
DimCustomer.SSB_CRMSYSTEM_CONTACT_ID
,forms.SubmitDate AS Activity_Date__c
,'Form Submit' AS Subject__c 
,Email + ' ; ' + WebAppLabel + ' ; ' + WebAppName + ' ; '  + URL AS Description__c
,forms.primarykey primarykey
FROM [ods].[Adobe_FormSubmits] forms WITH(NOLOCK)
JOIN dbo.vwDimCustomer_ModAcctId DimCustomer WITH (NOLOCK) ON DimCustomer.SourceSystem = 'Adobe' AND forms.AccountPrimaryKey = DimCustomer.SSID
WHERE 1=1
AND forms.SubmitDate > (SELECT DATEADD(d, -365, MAX([SubmitDate])) FROM [ods].[Adobe_FormSubmits] WITH (NOLOCK) )
--AND forms.SendSubmitstoSFDC = 1



GO
