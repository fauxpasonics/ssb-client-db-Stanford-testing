SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [etl].[Load_ods_Adobe_Recipient]
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
DECLARE @SrcRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM stg.Adobe_Recipient),'0');	
DECLARE @SrcDataSize NVARCHAR(255) = '0'

BEGIN TRY 

PRINT 'Execution Id: ' + CONVERT(NVARCHAR(100),@ExecutionId)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Procedure Processing', 'Start', @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Row Count', @SrcRowCount, @ExecutionId
EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src DataSize', @SrcDataSize, @ExecutionId

SELECT CAST(NULL AS BINARY(32)) ETL_DeltaHashKey, ETL__FileName, PrimaryKey, AccountId, AccountType, Address1, Address2, Address3, AllSports_Preferences, Baseball_Preferences, BusinessPhone, City, Company, ContactId_Preferences, CreationDate, CreationDate_Preferences, CrossCountry_Preferences, DateofBirth_Preferences, DaytimePhone, Email, EmailAddress_Preferences, EmailOptOut_Preferences, EmailVerified_Preferences, EmailVerifiedDate_Preferences, EveningPhone, Fax, Fencing_Preferences, FieldHockey_Preferences, FirstName, Football_Preferences, HomePhone, Lacrosse_Preferences, LastModified, LastModified_Preferences, LastName, Linked, LinkedEmail, MensBasketball_Preferences, MensGolf_Preferences, MensGymnastics_Preferences, MensRowing_Preferences, MensSoccer_Preferences, MensSwimmingandDiving_Preferences, MensTennis_Preferences, MensVolleyball_Preferences, MensWaterPolo_Preferences, MobilePhone, Quarantined_Preferences, QuarantinedReason_Preferences, RSVP1_Preferences, RSVP2_Preferences, RSVP3_Preferences, RSVP4_Preferences, Sailing_Preferences, Softball_Preferences, Squash_Preferences, State, SynchronizedSwimming_Preferences, TrackandField_Preferences, WomensBasketball_Preferences, WomensGolf_Preferences, WomensGymnastics_Preferences, WomensLightweightRowing_Preferences, WomensRowing_Preferences, WomensSandVolleyball_Preferences, WomensSoccer_Preferences, WomensSwimmingandDiving_Preferences, WomensTennis_Preferences, WomensVolleyball_Preferences, WomensWaterPolo_Preferences, Wrestling_Preferences, Zip
INTO #SrcData
FROM stg.Adobe_Recipient

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Loaded', @ExecutionId

UPDATE #SrcData
SET ETL_DeltaHashKey = HASHBYTES('sha2_256', ISNULL(RTRIM(AccountId),'DBNULL_TEXT') + ISNULL(RTRIM(AccountType),'DBNULL_TEXT') + ISNULL(RTRIM(Address1),'DBNULL_TEXT') + ISNULL(RTRIM(Address2),'DBNULL_TEXT') + ISNULL(RTRIM(Address3),'DBNULL_TEXT') + ISNULL(RTRIM(AllSports_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(Baseball_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(BusinessPhone),'DBNULL_TEXT') + ISNULL(RTRIM(City),'DBNULL_TEXT') + ISNULL(RTRIM(Company),'DBNULL_TEXT') + ISNULL(RTRIM(ContactId_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(CreationDate),'DBNULL_TEXT') + ISNULL(RTRIM(CreationDate_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(CrossCountry_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(DateofBirth_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(DaytimePhone),'DBNULL_TEXT') + ISNULL(RTRIM(Email),'DBNULL_TEXT') + ISNULL(RTRIM(EmailAddress_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(EmailOptOut_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(EmailVerified_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(EmailVerifiedDate_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(EveningPhone),'DBNULL_TEXT') + ISNULL(RTRIM(Fax),'DBNULL_TEXT') + ISNULL(RTRIM(Fencing_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(FieldHockey_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(FirstName),'DBNULL_TEXT') + ISNULL(RTRIM(Football_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(HomePhone),'DBNULL_TEXT') + ISNULL(RTRIM(Lacrosse_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(LastModified),'DBNULL_TEXT') + ISNULL(RTRIM(LastModified_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(LastName),'DBNULL_TEXT') + ISNULL(RTRIM(Linked),'DBNULL_TEXT') + ISNULL(RTRIM(LinkedEmail),'DBNULL_TEXT') + ISNULL(RTRIM(MensBasketball_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(MensGolf_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(MensGymnastics_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(MensRowing_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(MensSoccer_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(MensSwimmingandDiving_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(MensTennis_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(MensVolleyball_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(MensWaterPolo_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(MobilePhone),'DBNULL_TEXT') + ISNULL(RTRIM(PrimaryKey),'DBNULL_TEXT') + ISNULL(RTRIM(Quarantined_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(QuarantinedReason_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(RSVP1_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(RSVP2_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(RSVP3_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(RSVP4_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(Sailing_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(Softball_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(Squash_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(State),'DBNULL_TEXT') + ISNULL(RTRIM(SynchronizedSwimming_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(TrackandField_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(WomensBasketball_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(WomensGolf_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(WomensGymnastics_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(WomensLightweightRowing_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(WomensRowing_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(WomensSandVolleyball_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(WomensSoccer_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(WomensSwimmingandDiving_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(WomensTennis_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(WomensVolleyball_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(WomensWaterPolo_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(Wrestling_Preferences),'DBNULL_TEXT') + ISNULL(RTRIM(Zip),'DBNULL_TEXT'))

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'ETL_DeltaHashKey Set', @ExecutionId

CREATE NONCLUSTERED INDEX IDX_Load_Key ON #SrcData (PrimaryKey)
CREATE NONCLUSTERED INDEX IDX_ETL_DeltaHashKey ON #SrcData (ETL_DeltaHashKey)

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Src Table Setup', 'Temp Table Indexes Created', @ExecutionId

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Start', @ExecutionId

MERGE ods.Adobe_Recipient AS myTarget
USING #SrcData AS mySource
ON myTarget.PrimaryKey = mySource.PrimaryKey

WHEN MATCHED AND (
     ISNULL(mySource.ETL_DeltaHashKey,-1) <> ISNULL(myTarget.ETL__DeltaHashKey, -1)
)
THEN UPDATE SET
	  myTarget.[ETL__UpdatedDate] = @RunTime
	 ,myTarget.[ETL__IsDeleted] = 0
	 ,myTarget.[ETL__DeletedDate] = NULL
	 ,myTarget.[ETL__DeltaHashKey] = mySource.[ETL_DeltaHashKey]
	 ,myTarget.[ETL__FileName] = mySource.[ETL__FileName]
     ,myTarget.[PrimaryKey] = mySource.[PrimaryKey]
     ,myTarget.[AccountId] = mySource.[AccountId]
     ,myTarget.[AccountType] = mySource.[AccountType]
     ,myTarget.[Address1] = mySource.[Address1]
     ,myTarget.[Address2] = mySource.[Address2]
     ,myTarget.[Address3] = mySource.[Address3]
     ,myTarget.[AllSports_Preferences] = mySource.[AllSports_Preferences]
     ,myTarget.[Baseball_Preferences] = mySource.[Baseball_Preferences]
     ,myTarget.[BusinessPhone] = mySource.[BusinessPhone]
     ,myTarget.[City] = mySource.[City]
     ,myTarget.[Company] = mySource.[Company]
     ,myTarget.[ContactId_Preferences] = mySource.[ContactId_Preferences]
     ,myTarget.[CreationDate] = mySource.[CreationDate]
     ,myTarget.[CreationDate_Preferences] = mySource.[CreationDate_Preferences]
     ,myTarget.[CrossCountry_Preferences] = mySource.[CrossCountry_Preferences]
     ,myTarget.[DateofBirth_Preferences] = mySource.[DateofBirth_Preferences]
     ,myTarget.[DaytimePhone] = mySource.[DaytimePhone]
     ,myTarget.[Email] = mySource.[Email]
     ,myTarget.[EmailAddress_Preferences] = mySource.[EmailAddress_Preferences]
     ,myTarget.[EmailOptOut_Preferences] = mySource.[EmailOptOut_Preferences]
     ,myTarget.[EmailVerified_Preferences] = mySource.[EmailVerified_Preferences]
     ,myTarget.[EmailVerifiedDate_Preferences] = mySource.[EmailVerifiedDate_Preferences]
     ,myTarget.[EveningPhone] = mySource.[EveningPhone]
     ,myTarget.[Fax] = mySource.[Fax]
     ,myTarget.[Fencing_Preferences] = mySource.[Fencing_Preferences]
     ,myTarget.[FieldHockey_Preferences] = mySource.[FieldHockey_Preferences]
     ,myTarget.[FirstName] = mySource.[FirstName]
     ,myTarget.[Football_Preferences] = mySource.[Football_Preferences]
     ,myTarget.[HomePhone] = mySource.[HomePhone]
     ,myTarget.[Lacrosse_Preferences] = mySource.[Lacrosse_Preferences]
     ,myTarget.[LastModified] = mySource.[LastModified]
     ,myTarget.[LastModified_Preferences] = mySource.[LastModified_Preferences]
     ,myTarget.[LastName] = mySource.[LastName]
     ,myTarget.[Linked] = mySource.[Linked]
     ,myTarget.[LinkedEmail] = mySource.[LinkedEmail]
     ,myTarget.[MensBasketball_Preferences] = mySource.[MensBasketball_Preferences]
     ,myTarget.[MensGolf_Preferences] = mySource.[MensGolf_Preferences]
     ,myTarget.[MensGymnastics_Preferences] = mySource.[MensGymnastics_Preferences]
     ,myTarget.[MensRowing_Preferences] = mySource.[MensRowing_Preferences]
     ,myTarget.[MensSoccer_Preferences] = mySource.[MensSoccer_Preferences]
     ,myTarget.[MensSwimmingandDiving_Preferences] = mySource.[MensSwimmingandDiving_Preferences]
     ,myTarget.[MensTennis_Preferences] = mySource.[MensTennis_Preferences]
     ,myTarget.[MensVolleyball_Preferences] = mySource.[MensVolleyball_Preferences]
     ,myTarget.[MensWaterPolo_Preferences] = mySource.[MensWaterPolo_Preferences]
     ,myTarget.[MobilePhone] = mySource.[MobilePhone]
     ,myTarget.[Quarantined_Preferences] = mySource.[Quarantined_Preferences]
     ,myTarget.[QuarantinedReason_Preferences] = mySource.[QuarantinedReason_Preferences]
     ,myTarget.[RSVP1_Preferences] = mySource.[RSVP1_Preferences]
     ,myTarget.[RSVP2_Preferences] = mySource.[RSVP2_Preferences]
     ,myTarget.[RSVP3_Preferences] = mySource.[RSVP3_Preferences]
     ,myTarget.[RSVP4_Preferences] = mySource.[RSVP4_Preferences]
     ,myTarget.[Sailing_Preferences] = mySource.[Sailing_Preferences]
     ,myTarget.[Softball_Preferences] = mySource.[Softball_Preferences]
     ,myTarget.[Squash_Preferences] = mySource.[Squash_Preferences]
     ,myTarget.[State] = mySource.[State]
     ,myTarget.[SynchronizedSwimming_Preferences] = mySource.[SynchronizedSwimming_Preferences]
     ,myTarget.[TrackandField_Preferences] = mySource.[TrackandField_Preferences]
     ,myTarget.[WomensBasketball_Preferences] = mySource.[WomensBasketball_Preferences]
     ,myTarget.[WomensGolf_Preferences] = mySource.[WomensGolf_Preferences]
     ,myTarget.[WomensGymnastics_Preferences] = mySource.[WomensGymnastics_Preferences]
     ,myTarget.[WomensLightweightRowing_Preferences] = mySource.[WomensLightweightRowing_Preferences]
     ,myTarget.[WomensRowing_Preferences] = mySource.[WomensRowing_Preferences]
     ,myTarget.[WomensSandVolleyball_Preferences] = mySource.[WomensSandVolleyball_Preferences]
     ,myTarget.[WomensSoccer_Preferences] = mySource.[WomensSoccer_Preferences]
     ,myTarget.[WomensSwimmingandDiving_Preferences] = mySource.[WomensSwimmingandDiving_Preferences]
     ,myTarget.[WomensTennis_Preferences] = mySource.[WomensTennis_Preferences]
     ,myTarget.[WomensVolleyball_Preferences] = mySource.[WomensVolleyball_Preferences]
     ,myTarget.[WomensWaterPolo_Preferences] = mySource.[WomensWaterPolo_Preferences]
     ,myTarget.[Wrestling_Preferences] = mySource.[Wrestling_Preferences]
     ,myTarget.[Zip] = mySource.[Zip]
     
WHEN NOT MATCHED BY Target
THEN INSERT
     ([ETL__CreatedDate]
     ,[ETL__UpdatedDate]
	 ,[ETL__IsDeleted]
	 ,[ETL__DeletedDate]
     ,[ETL__DeltaHashKey]
     ,[ETL__FileName]
     ,[PrimaryKey]
     ,[AccountId]
     ,[AccountType]
     ,[Address1]
     ,[Address2]
     ,[Address3]
     ,[AllSports_Preferences]
     ,[Baseball_Preferences]
     ,[BusinessPhone]
     ,[City]
     ,[Company]
     ,[ContactId_Preferences]
     ,[CreationDate]
     ,[CreationDate_Preferences]
     ,[CrossCountry_Preferences]
     ,[DateofBirth_Preferences]
     ,[DaytimePhone]
     ,[Email]
     ,[EmailAddress_Preferences]
     ,[EmailOptOut_Preferences]
     ,[EmailVerified_Preferences]
     ,[EmailVerifiedDate_Preferences]
     ,[EveningPhone]
     ,[Fax]
     ,[Fencing_Preferences]
     ,[FieldHockey_Preferences]
     ,[FirstName]
     ,[Football_Preferences]
     ,[HomePhone]
     ,[Lacrosse_Preferences]
     ,[LastModified]
     ,[LastModified_Preferences]
     ,[LastName]
     ,[Linked]
     ,[LinkedEmail]
     ,[MensBasketball_Preferences]
     ,[MensGolf_Preferences]
     ,[MensGymnastics_Preferences]
     ,[MensRowing_Preferences]
     ,[MensSoccer_Preferences]
     ,[MensSwimmingandDiving_Preferences]
     ,[MensTennis_Preferences]
     ,[MensVolleyball_Preferences]
     ,[MensWaterPolo_Preferences]
     ,[MobilePhone]
     ,[Quarantined_Preferences]
     ,[QuarantinedReason_Preferences]
     ,[RSVP1_Preferences]
     ,[RSVP2_Preferences]
     ,[RSVP3_Preferences]
     ,[RSVP4_Preferences]
     ,[Sailing_Preferences]
     ,[Softball_Preferences]
     ,[Squash_Preferences]
     ,[State]
     ,[SynchronizedSwimming_Preferences]
     ,[TrackandField_Preferences]
     ,[WomensBasketball_Preferences]
     ,[WomensGolf_Preferences]
     ,[WomensGymnastics_Preferences]
     ,[WomensLightweightRowing_Preferences]
     ,[WomensRowing_Preferences]
     ,[WomensSandVolleyball_Preferences]
     ,[WomensSoccer_Preferences]
     ,[WomensSwimmingandDiving_Preferences]
     ,[WomensTennis_Preferences]
     ,[WomensVolleyball_Preferences]
     ,[WomensWaterPolo_Preferences]
     ,[Wrestling_Preferences]
     ,[Zip]
     )
VALUES
     (@RunTime	--	ETL_CreatedDate
     ,@RunTime	--	ETL_UpdateddDate
	 ,0			--	ETL__IsDeleted
	 ,NULL		--	ETL__DeletedDate
     ,mySource.[ETL_DeltaHashKey]
     ,mySource.[ETL__FileName]
     ,mySource.[PrimaryKey]
     ,mySource.[AccountId]
     ,mySource.[AccountType]
     ,mySource.[Address1]
     ,mySource.[Address2]
     ,mySource.[Address3]
     ,mySource.[AllSports_Preferences]
     ,mySource.[Baseball_Preferences]
     ,mySource.[BusinessPhone]
     ,mySource.[City]
     ,mySource.[Company]
     ,mySource.[ContactId_Preferences]
     ,mySource.[CreationDate]
     ,mySource.[CreationDate_Preferences]
     ,mySource.[CrossCountry_Preferences]
     ,mySource.[DateofBirth_Preferences]
     ,mySource.[DaytimePhone]
     ,mySource.[Email]
     ,mySource.[EmailAddress_Preferences]
     ,mySource.[EmailOptOut_Preferences]
     ,mySource.[EmailVerified_Preferences]
     ,mySource.[EmailVerifiedDate_Preferences]
     ,mySource.[EveningPhone]
     ,mySource.[Fax]
     ,mySource.[Fencing_Preferences]
     ,mySource.[FieldHockey_Preferences]
     ,mySource.[FirstName]
     ,mySource.[Football_Preferences]
     ,mySource.[HomePhone]
     ,mySource.[Lacrosse_Preferences]
     ,mySource.[LastModified]
     ,mySource.[LastModified_Preferences]
     ,mySource.[LastName]
     ,mySource.[Linked]
     ,mySource.[LinkedEmail]
     ,mySource.[MensBasketball_Preferences]
     ,mySource.[MensGolf_Preferences]
     ,mySource.[MensGymnastics_Preferences]
     ,mySource.[MensRowing_Preferences]
     ,mySource.[MensSoccer_Preferences]
     ,mySource.[MensSwimmingandDiving_Preferences]
     ,mySource.[MensTennis_Preferences]
     ,mySource.[MensVolleyball_Preferences]
     ,mySource.[MensWaterPolo_Preferences]
     ,mySource.[MobilePhone]
     ,mySource.[Quarantined_Preferences]
     ,mySource.[QuarantinedReason_Preferences]
     ,mySource.[RSVP1_Preferences]
     ,mySource.[RSVP2_Preferences]
     ,mySource.[RSVP3_Preferences]
     ,mySource.[RSVP4_Preferences]
     ,mySource.[Sailing_Preferences]
     ,mySource.[Softball_Preferences]
     ,mySource.[Squash_Preferences]
     ,mySource.[State]
     ,mySource.[SynchronizedSwimming_Preferences]
     ,mySource.[TrackandField_Preferences]
     ,mySource.[WomensBasketball_Preferences]
     ,mySource.[WomensGolf_Preferences]
     ,mySource.[WomensGymnastics_Preferences]
     ,mySource.[WomensLightweightRowing_Preferences]
     ,mySource.[WomensRowing_Preferences]
     ,mySource.[WomensSandVolleyball_Preferences]
     ,mySource.[WomensSoccer_Preferences]
     ,mySource.[WomensSwimmingandDiving_Preferences]
     ,mySource.[WomensTennis_Preferences]
     ,mySource.[WomensVolleyball_Preferences]
     ,mySource.[WomensWaterPolo_Preferences]
     ,mySource.[Wrestling_Preferences]
     ,mySource.[Zip]
     )
;

EXEC etl.LogEventRecordDB @Batchid, 'Info', @ProcedureName, 'Merge Load', 'Merge Statement Execution', 'Complete', @ExecutionId

DECLARE @MergeInsertRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Adobe_Recipient WHERE ETL__CreatedDate >= @RunTime AND ETL__UpdatedDate = ETL__CreatedDate),'0');	
DECLARE @MergeUpdateRowCount int = ISNULL((SELECT CONVERT(varchar, COUNT(*)) FROM ods.Adobe_Recipient WHERE ETL__UpdatedDate >= @RunTime AND ETL__UpdatedDate > ETL__CreatedDate),'0');	

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
