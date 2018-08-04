SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Load_ods_Adobe_DeliveryLog]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM stg.Adobe_DeliveryLog),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src DataSize', @SrcDataSize, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, ETL__CreatedDate, ETL__FileName, PrimaryKey, EventDate, InternalName, Address, Status, FailureType, Reason, DeliveryFK, AccountFK
INTO #SrcData
FROM stg.Adobe_DeliveryLog

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(AccountFK),'DBNULL_TEXT') + ISNULL(RTRIM(Address),'DBNULL_TEXT') + ISNULL(RTRIM(DeliveryFK),'DBNULL_TEXT') + ISNULL(RTRIM(EventDate),'DBNULL_TEXT') + ISNULL(RTRIM(FailureType),'DBNULL_TEXT') + ISNULL(RTRIM(InternalName),'DBNULL_TEXT') + ISNULL(RTRIM(PrimaryKey),'DBNULL_TEXT') + ISNULL(RTRIM(Reason),'DBNULL_TEXT') + ISNULL(RTRIM(Status),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (PrimaryKey)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Adobe_DeliveryLog AS myTarget
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
     ,myTarget.[EventDate] = mySource.[EventDate]
     ,myTarget.[InternalName] = mySource.[InternalName]
     ,myTarget.[Address] = mySource.[Address]
     ,myTarget.[Status] = mySource.[Status]
     ,myTarget.[FailureType] = mySource.[FailureType]
     ,myTarget.[Reason] = mySource.[Reason]
     ,myTarget.[DeliveryFK] = mySource.[DeliveryFK]
     ,myTarget.[AccountFK] = mySource.[AccountFK]
     
WHEN NOT MATCHED BY Target
THEN INSERT
     ([ETL__CreatedDate]
     ,[ETL__UpdatedDate]
     ,[ETL__DeltaHashKey]
     ,[ETL__FileName]
     ,[PrimaryKey]
     ,[EventDate]
     ,[InternalName]
     ,[Address]
     ,[Status]
     ,[FailureType]
     ,[Reason]
     ,[DeliveryFK]
     ,[AccountFK]
     )
VALUES
     (@RunTime --ETL_CreatedDate
     ,@RunTime --ETL_UpdateddDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ETL__FileName]
     ,mySource.[PrimaryKey]
     ,mySource.[EventDate]
     ,mySource.[InternalName]
     ,mySource.[Address]
     ,mySource.[Status]
     ,mySource.[FailureType]
     ,mySource.[Reason]
     ,mySource.[DeliveryFK]
     ,mySource.[AccountFK]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Adobe_DeliveryLog WHERE ETL__CreatedDate >= @RunTime AND ETL__UpdatedDate = ETL__CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Adobe_DeliveryLog WHERE ETL__UpdatedDate >= @RunTime AND ETL__UpdatedDate > ETL__CreatedDate),'0');	

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
