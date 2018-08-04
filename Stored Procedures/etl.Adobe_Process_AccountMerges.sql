SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



-- =============================================
-- Created By: Dan Horstman
-- Create Date: 2018-04-23
-- Reviewed By: Abbey Meitin
-- Reviewed Date: 2018-04-23
-- Description: FanOne Adobe Recipient Merge/Delete Process
-- =============================================


/*****	Revision History

DCH 2018-04-23	-	sproc creation.
ACM 2018-04-23  -   sproc reviewed

*****/


CREATE PROCEDURE [etl].[Adobe_Process_AccountMerges] 
AS
BEGIN


--	gather all unprocessed records
IF OBJECT_ID('tempdb..#accountMerges') IS NOT NULL
    DROP TABLE #accountMerges;

select *
into #accountMerges
from ods.Adobe_AccountMerges (nolock)
where ETL_IsProcessed = 0;

create nonclustered index idx_accountmerges on #accountMerges(ChildAdobeID,MergedPatron);


--	soft delete Adobe_Recipient records that have been merged
update a
set ETL__IsDeleted = 1
	, ETL__DeletedDate = GETDATE()
from ods.Adobe_Recipient a (nolock)
join #accountMerges b
	on a.PrimaryKey = b.ChildAdobeID
	and a.AccountId = b.MergedPatron
	and a.ETL__IsDeleted = 0;


--	update the IsProcessed flag so we don't continue to update the same records over and over again
update ods.Adobe_AccountMerges
set ETL_IsProcessed = 1
	, ETL_ProcessedDate = GETDATE()
where ETL_IsProcessed = 0;





END






GO
