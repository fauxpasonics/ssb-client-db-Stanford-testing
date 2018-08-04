SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [rpt].[vw_Adobe_FormSubmits]
AS	

SELECT  form.*, dc.SSB_CRMSYSTEM_CONTACT_ID
FROM    [ods].[Adobe_FormSubmits] form WITH (NOLOCK)
		LEFT JOIN dbo.dimcustomerssbid dc WITH (NOLOCK) ON dc.SourceSystem = 'Adobe' AND form.AccountPrimaryKey = dc.SSID







GO
