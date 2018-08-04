CREATE TABLE [ods].[Adobe_Delivery]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__UpdatedDate] [datetime] NOT NULL,
[ETL__DeltaHashKey] [binary] (32) NULL,
[ETL__FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryKey] [bigint] NOT NULL,
[ContactDate] [datetime] NULL,
[InternalName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Label] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessagestoSend] [int] NULL,
[Processed] [int] NULL,
[Success] [int] NULL,
[Errors] [int] NULL,
[RecipientsWhoHaveOpened] [int] NULL,
[TotalCountofOpens] [int] NULL,
[PersonsWhoHaveClicked] [int] NULL,
[TotalNumberofClicks] [int] NULL,
[NumberofDistinctClicks] [int] NULL,
[FolderId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FolderLabel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [ods].[Adobe_Delivery] ADD CONSTRAINT [PK__Adobe_De__A2D9E564DBDA9051] PRIMARY KEY CLUSTERED  ([PrimaryKey])
GO
