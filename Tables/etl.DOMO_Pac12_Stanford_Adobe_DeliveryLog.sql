CREATE TABLE [etl].[DOMO_Pac12_Stanford_Adobe_DeliveryLog]
(
[ETL__ID] [int] NOT NULL,
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__UpdatedDate] [datetime] NOT NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryKey] [bigint] NOT NULL,
[EventDate] [datetime] NULL,
[InternalName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FailureType] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Reason] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryFK] [bigint] NULL,
[AccountFK] [bigint] NULL
)
GO
