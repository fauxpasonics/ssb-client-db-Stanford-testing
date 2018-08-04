SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [rpt].[vw_Adobe_TrackingLog]
AS	

SELECT  trackinglog.*, delivery.Label, dc.SSB_CRMSYSTEM_CONTACT_ID
FROM    [ods].[Adobe_TrackingLog] trackinglog WITH (NOLOCK)
		LEFT JOIN [ods].[Adobe_Delivery] delivery WITH (NOLOCK) ON trackinglog.DeliveryFK = delivery.PrimaryKey
		LEFT JOIN dbo.dimcustomerssbid dc WITH (NOLOCK) ON dc.SourceSystem = 'Adobe' AND trackinglog.AccountFK = dc.SSID








GO
