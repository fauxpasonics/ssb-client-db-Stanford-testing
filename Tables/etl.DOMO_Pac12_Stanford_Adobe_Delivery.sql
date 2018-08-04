CREATE TABLE [etl].[DOMO_Pac12_Stanford_Adobe_Delivery]
(
[ETL__ID] [int] NOT NULL,
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
