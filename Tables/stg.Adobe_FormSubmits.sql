CREATE TABLE [stg].[Adobe_FormSubmits]
(
[ETL__ID] [int] NOT NULL IDENTITY(1, 1),
[ETL__CreatedDate] [datetime] NOT NULL,
[ETL__FileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrimaryKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountPrimaryKey] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PacId] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Email] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SubmitDate] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WebAppLabel] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WebAppName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[URL] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SendSubmitstoSFDC] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
