CREATE TABLE [ods].[Adobe_AccountMerges]
(
[ETL_ID] [int] NOT NULL IDENTITY(1, 1),
[ETL_CreatedDate] [datetime] NOT NULL CONSTRAINT [DF__Adobe_Acc__ETL_C__1A00556F] DEFAULT (getdate()),
[ETL_IsProcessed] [bit] NOT NULL CONSTRAINT [DF__Adobe_Acc__ETL_I__1AF479A8] DEFAULT ((0)),
[ETL_ProcessedDate] [datetime] NULL,
[ETL_FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MergeDate] [datetime] NOT NULL,
[MasterPatron] [bigint] NOT NULL,
[MergedPatron] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MasterAdobeID] [bigint] NOT NULL,
[ChildAdobeID] [bigint] NOT NULL
)
GO
