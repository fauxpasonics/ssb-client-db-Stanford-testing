SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [rpt].[DOMO_Pac12_Stanford_Adobe_FormSubmits]
AS
    BEGIN
        SELECT  *
        FROM    [rpt].[vw_Adobe_FormSubmits] WITH(NOLOCK)

    END



GO
