SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [rpt].[DOMO_Pac12_Stanford_Adobe_DeliveryLog]
AS
    BEGIN
        SELECT  *
        FROM    [rpt].[vw_Adobe_DeliveryLog] WITH(NOLOCK)

    END



GO
