SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [etl].[SSB_ProcessStandardMerge_SCD2]
(
	@BatchId NVARCHAR(50),
	@Target VARCHAR(256),
	@Source VARCHAR(256),
	@BusinessKey VARCHAR(256),
	@Options NVARCHAR(MAX)
)

AS
BEGIN

/**************************************Comments***************************************
**************************************************************************************
Mod #:		1
Name:		ssbcloud\zfrick
Date:		04/17/2016
Comments:	Dynamically generates and executes standard SSB Merge from source table to destination table.

*************************************************************************************/

DECLARE
     @SQL VARCHAR(MAX),
	 @SQL2 VARCHAR(MAX),
	 @SQL3 VARCHAR(MAX)

DECLARE
	 @ColString VARCHAR(MAX)
SET
	 @ColString = 
	 ( SELECT STUFF ((
                    SELECT ', ' + name 
                    FROM sys.columns
                    WHERE object_id = OBJECT_ID(@Source) -- and name not in ('ETL_ID')	DCH 2016-01-14		
					ORDER BY column_id		
                    FOR XML PATH('')), 1, 1, '') 
	 )

DECLARE
	 @HashSyntax VARCHAR(MAX)

DECLARE	 @HashTbl TABLE (HashSyntax VARCHAR(MAX))
INSERT @HashTbl (HashSyntax)
EXEC  etl.SSB_MergeHashFieldSyntax_v2 @Source

SET @HashSyntax = (SELECT TOP 1 HashSyntax FROM @HashTbl)

DECLARE
	 @JoinString varchar(MAX)
SET @JoinString = 
	(
		SELECT STUFF ((
        SELECT ' and ' + match  
        FROM
		(
			select 'myTarget.' + a.Item + ' = mySource.' + a.Item as match
			from dbo.Split (@BusinessKey, ',') a 
		)	x	
        FOR XML PATH('')), 1, 5, '')
	)

	DECLARE @SqlStringMax AS VARCHAR(MAX) = ''
	DECLARE @SchemaName  AS VARCHAR(255) = [dbo].[fnGetValueFromDelimitedString](@Source, '.' ,1)
	DECLARE @Table AS VARCHAR(255) = [dbo].[fnGetValueFromDelimitedString](@Source, '.' ,2)

	
	SELECT @SqlStringMax = @sqlStringMax + 'OR ISNULL(mySource.' + COLUMN_NAME + ','''') <> ' + 'ISNULL(myTarget.' + COLUMN_NAME + ','''') '
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_SCHEMA = @SchemaName AND TABLE_NAME = @Table
	AND ISNULL(CHARACTER_MAXIMUM_LENGTH, 0) < 0
--	AND COLUMN_NAME NOT IN ('ETL_ID')	DCH 2016-01-14

	
SELECT @SQL = 
'
DECLARE @RunTime DATETIME = GETDATE()

DECLARE @BatchId NVARCHAR(50) = ''' + @BatchId + ''';
DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @EventSource nvarchar(255) = ''ProcessStandardMerge_' + @Target + '''
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ' + @Source + '),''0'');	
DECLARE @SrcDataSize NVARCHAR(255) = ''0'';
DECLARE @Client NVARCHAR(255) = (SELECT ISNULL(etl.fnGetClientSetting(''ClientName''), DB_NAME()));

/*Load Options into a temp table*/
--SELECT Col1 AS OptionKey, Col2 as OptionValue INTO #Options FROM [dbo].[SplitMultiColumn](@Options, ''='', '';'')

--DECLARE @DisableDelete nvarchar(5) = ISNULL((SELECT OptionValue FROM #Options WHERE OptionKey = ''DisableDelete''),''true'')

BEGIN TRY 

PRINT ''Execution Id: '' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.CreateEventLogRecord @Batchid, @Client, ''Info'', @EventSource, ''Merge Load'', ''Procedure Processing'', ''Start'', @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, ''Info'', @EventSource, ''Merge Load'', ''Src Row Count'', @SrcRowCount, @ExecutionId
EXEC etl.CreateEventLogRecord @Batchid, @Client, ''Info'', @EventSource, ''Merge Load'', ''Src DataSize'', @SrcDataSize, @ExecutionId


SELECT ROW_NUMBER() OVER(ORDER BY ' + @BusinessKey + ') RowIndex
, * 
INTO #data
FROM ' + @Source + '

CREATE NONCLUSTERED INDEX IDX_RowIndex ON #data (RowIndex)

DECLARE @RecordCount INT = (SELECT COUNT(*) FROM #data)
DECLARE @StartIndex INT = 1, @PageCount INT = 25000
DECLARE @EndIndex INT = (@StartIndex + @PageCount - 1)

WHILE @StartIndex <= @RecordCount
BEGIN

SELECT CAST(NULL AS BINARY(32)) ETL__DeltaHashKey
, ' + @ColString + '
INTO #SrcData
FROM #data
WHERE RowIndex BETWEEN @StartIndex AND @EndIndex

EXEC etl.CreateEventLogRecord @Batchid, @Client, ''Info'', @EventSource, ''Merge Load'', ''Src Table Setup'', ''Temp Table Loaded'', @ExecutionId

UPDATE #SrcData
SET ETL__DeltaHashKey = ' + @HashSyntax + '

EXEC etl.CreateEventLogRecord @Batchid, @Client, ''Info'', @EventSource, ''Merge Load'', ''Src Table Setup'', ''ETL_Sync_DeltaHashKey Set'', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (' + @BusinessKey + ')
CREATE NONCLUSTERED INDEX IDX_ETL_Sync_DeltaHashKey ON #SrcData (ETL__DeltaHashKey)

EXEC etl.CreateEventLogRecord @Batchid, @Client, ''Info'', @EventSource, ''Merge Load'', ''Src Table Setup'', ''Temp Table Indexes Created'', @ExecutionId

EXEC etl.CreateEventLogRecord @Batchid, @Client, ''Info'', @EventSource, ''Merge Load'', ''Merge Statement Execution'', ''Start'', @ExecutionId
';

-------------------------------------------------------------------------------------------------

SELECT @SQL2 = 
'
MERGE ' + @Target + ' AS myTarget

USING (
	SELECT * FROM #SrcData
) AS mySource
    
	ON ' + @JoinString + '

WHEN MATCHED AND (
     ISNULL(mySource.ETL__DeltaHashKey,-1) <> ISNULL(myTarget.ETL__DeltaHashKey, -1)
	 AND myTarget.ETL__EndDate IS NULL
	 ' + @SqlStringMax + '
)
THEN UPDATE SET
	ETL__EndDate = @RunTime
';

-------------------------------------------------------------------------------------------------

SELECT @SQL3 = 
'WHEN NOT MATCHED BY Target
THEN INSERT
     (
		ETL__CreatedBy
		, ETL__CreatedDate
		, ETL__StartDate
		, ETL__DeltaHashKey
	 ' + 
          STUFF ((
                    SELECT ', [' + name + ']' + CHAR(10) + '     '
						FROM sys.columns
						WHERE object_id = OBJECT_ID(@Source)
--                         AND name <> 'ETL_ID'		DCH 2016-01-14
					ORDER BY column_id
                    FOR XML PATH('')), 1, 0, '') + ')
VALUES
     (
		SUSER_NAME() --ETL__CreatedBy
		, GETDATE() --ETL__CreatedDate
		, @RunTime	--ETL__StartDate
		, mySource.ETL__DeltaHashKey	
	 ' +
          STUFF ((
                    SELECT ', mySource.[' + name + ']' + CHAR(10) + '     '
						FROM sys.columns
						WHERE object_id = OBJECT_ID(@Source)
					ORDER BY column_id
                    FOR XML PATH('')), 1, 0, '') + ')
;

EXEC etl.CreateEventLogRecord @Batchid, @Client, ''Info'', @EventSource, ''Merge Load'', ''Merge Statement Execution'', ''Complete'', @ExecutionId

INSERT INTO ' + @Target + ' (
		ETL__CreatedBy
		, ETL__CreatedDate
		, ETL__StartDate
		, ETL__DeltaHashKey
	 ' + 
          STUFF ((
                    SELECT ', [' + name + ']' + CHAR(10) + '     '
						FROM sys.columns
						WHERE object_id = OBJECT_ID(@Source)
					ORDER BY column_id
                    FOR XML PATH('')), 1, 0, '') + ')

SELECT 
	SUSER_NAME() --ETL__CreatedBy
	, GETDATE() --ETL__CreatedDate
	, @RunTime	--ETL__StartDate
	, mySource.*
FROM #SrcData mySource
INNER JOIN ' + @Target + ' myTarget ON ' + @JoinString + '
WHERE myTarget.ETL__EndDate = @RunTime


DROP TABLE #SrcData

SET @StartIndex = @EndIndex + 1
SET @EndIndex = @EndIndex + @PageCount

END --End Of Paging Loop


DROP TABLE #data

END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.CreateEventLogRecord @Batchid, @Client, ''Error'', @EventSource, ''Merge Load'', ''Merge Error'', @ErrorMessage, @ExecutionId
	EXEC etl.CreateEventLogRecord @Batchid, @Client, ''Info'', @EventSource, ''Merge Load'', ''Procedure Processing'', ''Complete'', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.CreateEventLogRecord @Batchid, @Client, ''Info'', @EventSource, ''Merge Load'', ''Procedure Processing'', ''Complete'', @ExecutionId
'

--PRINT @SQL
--PRINT @SQL2 
--PRINT @SQL3

DECLARE @Full_SQL NVARCHAR(MAX) = @SQL + @SQL2 + @SQL3;

--SELECT @Full_SQL

IF (@Options LIKE 'RunMode:Debug')
BEGIN

PRINT @SQL
PRINT @SQL2 
PRINT @SQL3

END
ELSE BEGIN

EXEC (@Full_SQL)

END

END



GO
