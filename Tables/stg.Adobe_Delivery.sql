CREATE TABLE [stg].[Adobe_Delivery]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ContactDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[InternalName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Label] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessagestoSend] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Processed] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Success] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Errors] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecipientsWhoHaveOpened] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalCountofOpens] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PersonsWhoHaveClicked] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TotalNumberofClicks] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumberofDistinctClicks] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FolderId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FolderLabel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
