SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_ods_Adobe_Delivery]
(
	@BatchId INT = 0,
	@Options NVARCHAR(MAX) = null
)
AS 

BEGIN
/**************************************Comments***************************************
**************************************************************************************
Mod #:  1
Name:     SSBCLOUD\dhorstman
Date:     12/19/2016
Comments: Initial creation
*************************************************************************************/

DECLARE @RunTime DATETIME = GETDATE()

DECLARE @ExecutionId uniqueidentifier = newid();
DECLARE @ProcedureName nvarchar(255) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM stg.Adobe_Delivery),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src DataSize', @SrcDataSize, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, ETL__CreatedDate, ETL__FileName, PrimaryKey, ContactDate, InternalName, Label, MessagestoSend, Processed, Success, Errors, RecipientsWhoHaveOpened, TotalCountofOpens, PersonsWhoHaveClicked, TotalNumberofClicks, NumberofDistinctClicks, FolderId, FolderLabel
INTO #SrcData
FROM stg.Adobe_Delivery

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(ContactDate),'DBNULL_TEXT') + ISNULL(RTRIM(Errors),'DBNULL_TEXT') + ISNULL(RTRIM(FolderId),'DBNULL_TEXT') + ISNULL(RTRIM(FolderLabel),'DBNULL_TEXT') + ISNULL(RTRIM(InternalName),'DBNULL_TEXT') + ISNULL(RTRIM(Label),'DBNULL_TEXT') + ISNULL(RTRIM(MessagestoSend),'DBNULL_TEXT') + ISNULL(RTRIM(NumberofDistinctClicks),'DBNULL_TEXT') + ISNULL(RTRIM(PersonsWhoHaveClicked),'DBNULL_TEXT') + ISNULL(RTRIM(PrimaryKey),'DBNULL_TEXT') + ISNULL(RTRIM(Processed),'DBNULL_TEXT') + ISNULL(RTRIM(RecipientsWhoHaveOpened),'DBNULL_TEXT') + ISNULL(RTRIM(Success),'DBNULL_TEXT') + ISNULL(RTRIM(TotalCountofOpens),'DBNULL_TEXT') + ISNULL(RTRIM(TotalNumberofClicks),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (PrimaryKey)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Adobe_Delivery AS myTarget
USING #SrcData AS mySource
ON myTarget.PrimaryKey = mySource.PrimaryKey

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL__DeltaHashKey, -1)
)
THEN UPDATE SET
	  myTarget.[ETL__UpdatedDate] = @RunTime
	 ,myTarget.[ETL__DeltaHashKey] = mySource.[ETL_DeltaHashKey]
	 ,myTarget.[ETL__FileName] = mySource.[ETL__FileName]
     ,myTarget.[PrimaryKey] = mySource.[PrimaryKey]
     ,myTarget.[ContactDate] = mySource.[ContactDate]
     ,myTarget.[InternalName] = mySource.[InternalName]
     ,myTarget.[Label] = mySource.[Label]
     ,myTarget.[MessagestoSend] = mySource.[MessagestoSend]
     ,myTarget.[Processed] = mySource.[Processed]
     ,myTarget.[Success] = mySource.[Success]
     ,myTarget.[Errors] = mySource.[Errors]
     ,myTarget.[RecipientsWhoHaveOpened] = mySource.[RecipientsWhoHaveOpened]
     ,myTarget.[TotalCountofOpens] = mySource.[TotalCountofOpens]
     ,myTarget.[PersonsWhoHaveClicked] = mySource.[PersonsWhoHaveClicked]
     ,myTarget.[TotalNumberofClicks] = mySource.[TotalNumberofClicks]
     ,myTarget.[NumberofDistinctClicks] = mySource.[NumberofDistinctClicks]
     ,myTarget.[FolderId] = mySource.[FolderId]
     ,myTarget.[FolderLabel] = mySource.[FolderLabel]
     
WHEN NOT MATCHED BY Target
THEN INSERT
     ([ETL__CreatedDate]
     ,[ETL__UpdatedDate]
     ,[ETL__DeltaHashKey]
     ,[ETL__FileName]
     ,[PrimaryKey]
     ,[ContactDate]
     ,[InternalName]
     ,[Label]
     ,[MessagestoSend]
     ,[Processed]
     ,[Success]
     ,[Errors]
     ,[RecipientsWhoHaveOpened]
     ,[TotalCountofOpens]
     ,[PersonsWhoHaveClicked]
     ,[TotalNumberofClicks]
     ,[NumberofDistinctClicks]
     ,[FolderId]
     ,[FolderLabel]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ETL__FileName]
     ,mySource.[PrimaryKey]
     ,mySource.[ContactDate]
     ,mySource.[InternalName]
     ,mySource.[Label]
     ,mySource.[MessagestoSend]
     ,mySource.[Processed]
     ,mySource.[Success]
     ,mySource.[Errors]
     ,mySource.[RecipientsWhoHaveOpened]
     ,mySource.[TotalCountofOpens]
     ,mySource.[PersonsWhoHaveClicked]
     ,mySource.[TotalNumberofClicks]
     ,mySource.[NumberofDistinctClicks]
     ,mySource.[FolderId]
     ,mySource.[FolderLabel]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Adobe_Delivery WHERE ETL__CreatedDate >= @RunTime AND ETL__UpdatedDate = ETL__CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Adobe_Delivery WHERE ETL__UpdatedDate >= @RunTime AND ETL__UpdatedDate > ETL__CreatedDate),'0');	

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Insert Row Count', @MergeInsertRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Update Row Count', @MergeUpdateRowCount, @ExecutionId


END TRY 
BEGIN CATCH 

	DECLARE @ErrorMessage nvarchar(4000) = ERROR_MESSAGE();
	DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
	DECLARE @ErrorState INT = ERROR_STATE();
			
	PRINT @ErrorMessage
	EXEC etl.LogEventRecordDB @Batchid, 'Error', @ProcedureName, 'Merge Load', 'Merge Error', @ErrorMessage, @ExecutionId
	EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

END CATCH

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Complete', @ExecutionId


END

GO
