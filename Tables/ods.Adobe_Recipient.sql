CREATE TABLE [ods].[Adobe_Recipient]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__Adobe_Rec__ETL____1EC50A8C] DEFAULT (getdate()),
[ETL__UpdatedDate] [datetime] NOT NULL CONSTRAINT [DF__Adobe_Rec__ETL____1FB92EC5] DEFAULT (getdate()),
[ETL__IsDeleted] [bit] NOT NULL CONSTRAINT [DF__Adobe_Rec__ETL____20AD52FE] DEFAULT ((0)),
[ETL__DeletedDate] [datetime] NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryKey] [bigint] NOT NULL,
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
[CreationDate] [datetime] NULL,
[CreationDate_Preferences] [datetime] NULL,
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
[LastModified] [datetime] NULL,
[LastModified_Preferences] [datetime] NULL,
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
ALTER TABLE [ods].[Adobe_Recipient] ADD CONSTRAINT [PK__Adobe_Re__A2D9E564D125A444] PRIMARY KEY CLUSTERED  ([PrimaryKey])
GO
CREATE NONCLUSTERED INDEX [IX_Adobe_Recipient__Email] ON [ods].[Adobe_Recipient] ([Email]) INCLUDE ([EmailOptOut_Preferences])
GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-Email] ON [ods].[Adobe_Recipient] ([EmailAddress_Preferences])
GO