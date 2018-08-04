SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE VIEW [rpt].[vw_Adobe_Delivery]
AS	

SELECT  delivery.*
FROM    [ods].[Adobe_Delivery] delivery WITH (NOLOCK)






GO
