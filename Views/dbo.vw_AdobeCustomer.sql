SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


/****** 

DCH 2018-07-11	-	need to explicitly cast email as nvarchar(256) due to changes in dbo.vwDimCustomer_ModAcctID

******/

CREATE VIEW [dbo].[vw_AdobeCustomer]
AS

SELECT  CAST(a.SSB_CRMSYSTEM_CONTACT_ID AS VARCHAR(100)) AS [guid],
a.[SSB_CRMSYSTEM_PRIMARY_FLAG] Contact_PrimaryFlag,
a.SourceSystem, 
a.SSID, 
CAST(a.EmailPrimary as nvarchar(256)) AS email,
CAST(acct.Id AS VARCHAR(50)) AS crmId,
a.FirstName, a.LastName, 
a.AddressPrimaryStreet BillingStreet, a.AddressPrimaryCity BillingCity, a.AddressPrimaryState BillingState, a.AddressPrimaryZip BillingPostalCode, 
a.PhoneCell PersonMobilePhone, a.PhoneHome PersonHomePhone, a.PhonePrimary Phone,
a.UpdatedDate
FROM dbo.vwDimCustomer_ModAcctID (NOLOCK)  a
	LEFT JOIN (
					SELECT SSB_CRMSYSTEM_Contact_ID__c
					,Id
					, ROW_NUMBER() OVER(PARTITION BY SSB_CRMSYSTEM_Contact_ID__c ORDER BY LastModifiedDate DESC, CreatedDate) xRank
					FROM [Stanford_Reporting].[ProdCopy].[Account] acct (NOLOCK) 
					WHERE acct.IsDeleted = '0') acct ON a.SSB_CRMSYSTEM_CONTACT_ID = acct.SSB_CRMSYSTEM_CONTACT_ID__c AND acct.xRank = 1
WHERE a.[SourceSystem] NOT LIKE '%SFDC%'




GO
