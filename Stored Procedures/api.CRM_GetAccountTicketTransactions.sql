SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








-- ==========================================================================================
-- Author:		Abbey Meitin
-- Create date: 3/2/17
-- Description:	Ticket Transaction API View for Salesforce
-- ==========================================================================================


CREATE PROCEDURE [api].[CRM_GetAccountTicketTransactions]
(
    @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'Test',
	@SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'Test',
	@DisplayTable INT = 0,
	@RowsPerPage  INT = 500,
	@PageNumber   INT = 0,
	@ViewResultInTable INT = 0
)
WITH RECOMPILE
AS

BEGIN

IF OBJECT_ID('tempdb..#BASE')IS NOT NULL DROP TABLE #BASE
IF OBJECT_ID('tempdb..#PatronList')IS NOT NULL DROP TABLE #PatronList


--DECLARE @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'Test'
--DECLARE @SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = '471E21BD-CEB4-4EA1-800D-D2B18E886483'
--DECLARE @DisplayTable INT = 0
--DECLARE @RowsPerPage  INT = 500
--DECLARE @PageNumber   INT = 0
--DECLARE @ViewResultInTable INT = 0
/*===================================================================================================
												DECLARE VARIABLES
===================================================================================================*/

DECLARE @totalCount      INT
	,@xmlDataNode        XML
	,@recordsInResponse  INT
	,@remainingCount     INT
	,@rootNodeName       NVARCHAR(100)
	,@responseInfoNode   NVARCHAR(MAX)
	,@finalXml           XML
	,@PatronID varchar(500)

DECLARE @GUIDTable TABLE (
GUID VARCHAR(50)
)

IF (@SSB_CRMSYSTEM_ACCT_ID NOT IN ('None','Test'))
BEGIN
	INSERT INTO @GUIDTable
	SELECT DISTINCT z.SSB_CRMSYSTEM_CONTACT_ID
	FROM dbo.vwDimCustomer_ModAcctId z 
	WHERE z.SSB_CRMSYSTEM_ACCT_ID = @SSB_CRMSYSTEM_ACCT_ID
END

IF (@SSB_CRMSYSTEM_CONTACT_ID NOT IN ('None','Test'))
BEGIN
	INSERT INTO @GUIDTable
	SELECT @SSB_CRMSYSTEM_CONTACT_ID
END

DECLARE @Parent TABLE (
ParentValue VARCHAR(500)
, ParentLabel VARCHAR(500)
, AggregateValue MONEY
, AggregateValue1 MONEY
)	

/*===================================================================================================
												SSID's
===================================================================================================*/


SELECT a.[SSID] 
INTO #PatronList
FROM dbo.[vwDimCustomer_ModAcctId] (nolock) a
	JOIN @GUIDTable guids on guids.[GUID] = a.SSB_CRMSYSTEM_CONTACT_ID
WHERE a.SourceSystem = 'Stanford_TI'

SET @PatronID = (SELECT SUBSTRING(
(SELECT ',' + s.SSID
FROM [#PatronList] s
ORDER BY s.SSID
FOR XML PATH('')),2,200000) AS CSV)

/*===================================================================================================
												BASE
===================================================================================================*/

CREATE TABLE #BASE (
    [TEAM] [VARCHAR](100) NOT NULL	
   ,[SEASON] [VARCHAR](15) NOT NULL
   ,[SEASONNAME] [VARCHAR](128) NULL
   ,[ORDERNUMBER] [VARCHAR](48) NULL
   ,[ORDERLINE] [BIGINT] NOT NULL
   ,[CUSTOMER] [VARCHAR](20) NOT NULL
   ,[BASIS] [VARCHAR](10) NULL
   ,[DISPOSITION] [VARCHAR](32) NULL
   ,[ITEM] [VARCHAR](32) NULL
   ,[ITEM_NAME] [VARCHAR](256) NULL
   ,[PRICE_TYPE] [VARCHAR](32) NULL
   ,[PRICE_TYPE_NAME] [VARCHAR](128) NULL
   ,[PRICE_LEVEL] [VARCHAR](10) NULL
   ,[PRICE_LEVEL_NAME] [VARCHAR](128) NULL
   ,[TICKET_PRICE] [NUMERIC](18, 2) NULL
   ,[ORDER_DATE] [DATETIME] NULL
   ,[ORDER_QTY] [BIGINT] NULL
   ,[ORDER_AMT] [NUMERIC](38, 2) NULL
   ,[Total_Paid] [NUMERIC](18, 2) NULL
   ,[BALANCE_REMAINING] [NUMERIC](38, 2) NULL
   ,[MINPMTDATE] DATE NULL
   ,[ORIG_SALECODE] [VARCHAR](32) NULL
   ,[ORIG_SALECODE_NAME] [VARCHAR](32) NULL
   ,[PROMO] [VARCHAR](32) NULL
   ,[PROMO_NAME] [VARCHAR](128) NULL
   ,[MARK_CODE] [varchar](32) NULL
   ,[INREFSOURCE] [varchar](128) NULL
   ,[INREFDATA] [varchar](128) NULL
   ,[SEAT_BLOCK] [varchar](8000) NULL
   ,[ODET_EXPORT_DATETIME] [datetime] NULL
   ,[ITEM_EXPORT_DATETIME] [datetime] NULL
   ,[PAYMENTPLAN] VARCHAR(500) NULL
   ,[maxchangedate] [datetime] NULL
)

INSERT INTO #BASE

SELECT 'Stanford' as TEAM
	  ,tkOdet.SEASON 
	  ,tkSeason.NAME SEASONNAME
	  ,tkOdet.SEASON + ':' + tkOdet.ZID   ORDERNUMBER
	  ,tkOdet.SEQ		ORDERLINE
	  ,tkOdet.CUSTOMER
	  ,tkItem.BASIS
	  ,tkOdet.I_DISP DISPOSITION
	  ,tkOdet.ITEM
	  ,[tkItem].[NAME] ITEM_NAME
	  ,tkOdet.I_PT PRICE_TYPE
	  ,[tkPriceType].[NAME] PRICE_TYPE_NAME
	  ,tkOdet.I_PL PRICE_LEVEL
	  ,tkPriceLevel.PL_Name PRICE_LEVEL_NAME
	  ,I_PRICE TICKET_PRICE
	  ,tkOdet.I_DATE ORDER_DATE  
	  ,tkOdet.I_OQTY ORDER_QTY
	  ,tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT + tkOdet.I_FPRICE) AS   ORDER_AMT
	  ,tkodet.[I_PAY] Total_Paid
	  ,((tkOdet.I_OQTY * (tkOdet.I_PRICE - tkOdet.I_DAMT + tkOdet.I_FPRICE)) - tkOdet.I_PAY) BALANCE_REMAINING
	  ,CASE WHEN I_PAY <> 0 THEN NULLIF(PaidFinal.MINPMTDATE,'1900-01-01')  ELSE NULL END AS MINPMTDATE
	  ,tkOdet.ORIG_SALECODE 
	  ,SALECODE.NAME Orig_Salescode_Name
	  ,tkOdet.PROMO
	  ,tkPromo.Name PROMO_NAME
	  ,tkOdet.I_MARK MARK_CODE
	  ,tkOdet.INREFSOURCE
	  ,tkOdet.INREFDATA
	  ,tkOdet.E_SBLS_1 AS SEAT_BLOCK 
	  ,tkOdet.EXPORT_DATETIME AS ODET_EXPORT_DATETIME
	  ,tkItem.EXPORT_DATETIME AS ITEM_EXPORT_DATETIME
	  ,tkOdet.I_BPTYPE PaymentPlan
	  ,CASE WHEN tkOdet.EXPORT_DATETIME > tkItem.EXPORT_DATETIME 
				 AND tkOdet.EXPORT_DATETIME > ISNULL(PaidFinal.MINPMTDATE,'1900-01-01') 
			THEN tkOdet.EXPORT_DATETIME			
			WHEN tkItem.EXPORT_DATETIME > tkOdet.EXPORT_DATETIME 
				 AND tkItem.EXPORT_DATETIME > ISNULL(PaidFinal.MINPMTDATE,'1900-01-01')
			THEN tkItem.EXPORT_DATETIME			
			ELSE ISNULL(PaidFinal.MINPMTDATE,'1900-01-01') 
       END AS maxchangedate 	
FROM TK_ODET tkOdet 
	JOIN #PatronList list on list.SSID = tkOdet.Customer
	JOIN TK_ITEM tkItem (NOLOCK) ON tkOdet.SEASON = tkItem.SEASON AND tkOdet.ITEM = tkItem.ITEM
	JOIN TK_SEASON tkSeason (NOLOCK) ON tkOdet.SEASON = tkSeason.SEASON
	LEFT JOIN TK_PTABLE_PRLEV tkPriceLevel (NOLOCK) ON [tkOdet].[I_PL] = [tkPriceLevel].PL 
													 AND [tkItem].Ptable = [tkPriceLevel].PTable
													 AND [tkOdet].[SEASON] = [tkPriceLevel].Season
	LEFT JOIN dbo.[TK_PRTYPE] tkPriceType (NOLOCK) ON tkOdet.SEASON = tkPriceType.SEASON AND tkOdet.I_PT = tkPriceType.PRTYPE 
	LEFT JOIN [dbo].[TK_PROMO] tkPromo (NOLOCK) ON tkodet.[PROMO] = [tkPromo].[PROMO]
	LEFT JOIN dbo.TK_SALECODE SALECODE (NOLOCK) ON SALECODE.SALECODE = tkOdet.ORIG_SALECODE
	LEFT JOIN ( SELECT tkTransItem.CUSTOMER
					  ,MIN(tkTrans.DATE) MINPMTDATE
					  ,tkTransItem.ITEM
					  ,tkTransItem.I_PT 
					  ,tkTransItem.SEASON 
			    FROM dbo.TK_TRANS tkTrans
					JOIN dbo.TK_TRANS_ITEM tkTransItem (NOLOCK) ON tkTrans.Season = tkTransItem.Season AND tkTrans.Trans_No = tkTransItem.Trans_No
					JOIN #PatronList list on list.SSID = tkTransItem.Customer
					JOIN dbo.TK_TRANS_ITEM_PAYMODE tkTransItemPaymode (NOLOCK) ON tkTransItem.SEASON = tkTransItemPaymode.SEASON 
																		 AND tkTransItem.TRANS_NO = tkTransItemPaymode.TRANS_NO 
																		 AND tkTransItem.VMC = tkTransItemPaymode.VMC
					JOIN  dbo.TK_ITEM tkItem (NOLOCK) ON tkTransItem.SEASON = tkItem.SEASON AND tkTransItem.ITEM = tkItem.ITEM
				WHERE tkTransItemPaymode.I_PAY_TYPE = 'I'
				GROUP BY
					 tkTransItem.CUSTOMER
					,tkTransItem.ITEM
					,tkTransItem.I_PT
					,tkTransItem.SEASON
				HAVING SUM(ISNULL((tkTransItemPaymode.I_PAY_PAMT ),0)) > 0 
			  ) PaidFinal ON tkOdet.CUSTOMER = PaidFinal.CUSTOMER
							 AND tkOdet.ITEM = PaidFinal.ITEM
							 AND ISNULL(tkOdet.I_PT, 99999)  = ISNULL(PaidFinal.I_PT,99999) 
							 AND tkOdet.SEASON = PaidFinal.SEASON 
ORDER BY Order_Date DESC, [ORDERLINE]
OFFSET (@PageNumber) * @RowsPerPage ROWS
FETCH NEXT @RowsPerPage ROWS ONLY

/*===================================================================================================
												CREATE XML
===================================================================================================*/

IF @ViewResultinTable = 1
BEGIN
	PRINT @PatronID
END

 SET @totalCount = @@ROWCOUNT

 INSERT INTO @Parent
         ( [ParentValue] ,
           [ParentLabel] ,
           [AggregateValue],
		   [AggregateValue1]
         )
 SELECT [SEASON]
		, SeasonName ParentLabel
		, SUM([ORDER_AMT]) OrderValue
		, SUM([BALANCE_REMAINING]) Balance 
 FROM [#BASE] GROUP BY Season, [SEASONNAME] ORDER BY SEASON DESC

-- Cap returned results at 1000
IF @RowsPerPage > 1000
BEGIN
	SET @RowsPerPage = 1000;
END
	
-- Pull total count
SELECT @totalCount = COUNT(*)
FROM #BASE


-- Set records in response
SET @recordsInResponse  = (SELECT COUNT(*) FROM #BASE)

-- Create XML response data node
SET @xmlDataNode = (
SELECT [ParentValue] Season , [ParentLabel] AS [Season_Name],
CASE WHEN SIGN(ISNULL([AggregateValue] ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([AggregateValue])), '0.00') AS [Order_Value],
CASE WHEN SIGN(ISNULL([AggregateValue1] ,'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([AggregateValue1])), '0.00') AS [Order_Balance],
	(SELECT ISNULL(CUSTOMER,'') AS Customer 
		   ,CONVERT(DATE, ISNULL([ORDER_DATE],''),102) AS [Order_Date] 
		   ,ISNULL([ITEM_NAME],'') AS [Item_Name] 
		   ,ISNULL([ITEM],'') AS [Item] 
		   ,REPLACE(ISNULL([PRICE_TYPE_NAME],'') + ' (' + ISNULL([PRICE_TYPE],'') + ')','()','') AS [Price_Type] 
		   ,REPLACE(ISNULL([PRICE_LEVEL_NAME],'') + ' (' + ISNULL([PRICE_LEVEL],'') + ')','()','') AS [Price_Level] 
		   ,ISNULL([ORDER_QTY],0) AS [Order_Qty] 
		   ,ISNULL([SEAT_BLOCK],'') AS [Seat_Block] 
		   ,CASE WHEN SIGN(ISNULL([TICKET_PRICE],'')) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([TICKET_PRICE])), '0.00') AS [Ticket_Price] 
		   ,CASE WHEN SIGN(ISNULL([ORDER_AMT],0)) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS(ORDER_AMT)), '0.00') AS [Order_Amt] 
		   ,CASE WHEN SIGN(ISNULL([Total_Paid],0)) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([Total_Paid])), '0.00')  AS [Total_Paid] 
		   ,CASE WHEN SIGN(ISNULL([BALANCE_REMAINING],0)) <0 THEN '-' ELSE '' END + '$' + ISNULL(CONVERT(VARCHAR(12),ABS([BALANCE_REMAINING])), '0.00') AS [Balance_Remaining] 
		   ,ISNULL(PaymentPlan,'') AS Payment_Plan 
		   ,REPLACE(ISNULL([PROMO_NAME],'') + ' (' + ISNULL([PROMO],'') + ')','()','') AS [Promo] 
		   ,ISNULL([DISPOSITION],'') AS [Disposition] 
		   ,ISNULL([ORIG_SALECODE_NAME],'') AS [Orig_Salecode_Name] 
		   ,ISNULL([ORIG_SALECODE],'') AS [Orig_Salecode] 
		   ,ISNULL([ORDERNUMBER],'') AS [Order_Number] 
		   ,ISNULL(NULLIF(CONVERT(VARCHAR(50),[MINPMTDATE],102),'1900-01-01'),'') AS [Min_Pmt_Date] 
		   ,'' [Break]
	 FROM #BASE c
	 WHERE c.season = p.ParentValue
	 ORDER BY ORDER_DATE DESC, [Order_Number] DESC, ORDERLINE DESC
	 FOR XML PATH ('Child'), TYPE) AS 'Children'
FROM @Parent AS p  
FOR XML PATH ('Parent'), ROOT('Parents'))

SET @rootNodeName = 'Parents'
	
-- Calculate remaining count
SET @remainingCount = @totalCount - (@RowsPerPage * (@PageNumber + 1))
IF @remainingCount < 0
BEGIN
	SET @remainingCount = 0
END

-- Create response info node
SET @responseInfoNode = ('<ResponseInfo>'
	+ '<TotalCount>' + CAST(@totalCount AS NVARCHAR(20)) + '</TotalCount>'
	+ '<RemainingCount>' + CAST(@remainingCount AS NVARCHAR(20)) + '</RemainingCount>'
	+ '<RecordsInResponse>' + CAST(@recordsInResponse AS NVARCHAR(20)) + '</RecordsInResponse>'
	+ '<PagedResponse>true</PagedResponse>'
	+ '<RowsPerPage>' + CAST(@RowsPerPage AS NVARCHAR(20)) + '</RowsPerPage>'
	+ '<PageNumber>' + CAST(@PageNumber AS NVARCHAR(20)) + '</PageNumber>'
	+ '<RootNodeName>' + @rootNodeName + '</RootNodeName>'
	+ '</ResponseInfo>')

	
-- Wrap response info and data, then return	
IF @xmlDataNode IS NULL
BEGIN
	SET @xmlDataNode = '<' + @rootNodeName + ' />' 
END
		
SET @finalXml = '<Root>' + @responseInfoNode + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>'

IF @ViewResultinTable = 0
BEGIN
SELECT CAST(@finalXml AS XML)
END
ELSE 
BEGIN
SELECT * FROM #BASE
END

END


DROP TABLE #BASE
DROP TABLE #PatronList







GO
