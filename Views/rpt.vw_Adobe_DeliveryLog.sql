SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO










CREATE VIEW [rpt].[vw_Adobe_DeliveryLog]
AS	

SELECT  deliverylog.*
FROM    [ods].[Adobe_DeliveryLog] deliverylog WITH (NOLOCK)
		






GO
