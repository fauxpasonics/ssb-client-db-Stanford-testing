CREATE TABLE [stg].[Adobe_Recipient]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address1] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address3] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AllSports_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Baseball_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Company] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactId_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationDate_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CrossCountry_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DateofBirth_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DaytimePhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailAddress_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailOptOut_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailVerified_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailVerifiedDate_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EveningPhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fax] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Fencing_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FieldHockey_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Football_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HomePhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Lacrosse_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastModified] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastModified_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Linked] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LinkedEmail] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MensBasketball_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MensGolf_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MensGymnastics_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MensRowing_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MensSoccer_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MensSwimmingandDiving_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MensTennis_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MensVolleyball_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MensWaterPolo_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobilePhone] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Quarantined_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QuarantinedReason_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RSVP1_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RSVP2_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RSVP3_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RSVP4_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sailing_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Softball_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Squash_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SynchronizedSwimming_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TrackandField_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WomensBasketball_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WomensGolf_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WomensGymnastics_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WomensLightweightRowing_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WomensRowing_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WomensSandVolleyball_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WomensSoccer_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WomensSwimmingandDiving_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WomensTennis_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WomensVolleyball_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WomensWaterPolo_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Wrestling_Preferences] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO