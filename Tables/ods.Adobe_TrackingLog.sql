CREATE TABLE [ods].[Adobe_TrackingLog]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__UpdatedDate] [datetime] NOT NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryKey] [bigint] NOT NULL,
[TrackingDate] [datetime] NULL,
[Email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryFK] [bigint] NULL,
[AccountFK] [bigint] NULL,
[InternalName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[URLType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[URLLabel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SourceURL] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Browser] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[Adobe_TrackingLog] ADD CONSTRAINT [PK__Adobe_Tr__A2D9E5647EDC045B] PRIMARY KEY CLUSTERED  ([PrimaryKey])
GO
