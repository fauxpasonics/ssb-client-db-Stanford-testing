SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[fn_APIView_Trans]
(
	@Customers VARCHAR(MAX)
)
RETURNS 
@ReturnTable TABLE 
(
	[SEASON] [VARCHAR](15) NOT NULL,
	[SEASONNAME] [VARCHAR](128) NULL,
	[ORDER_LINE_ID] [VARCHAR](48) NULL,
	[ORDER_SEQUENCE] [BIGINT] NOT NULL,
	[CUSTOMER] [VARCHAR](20) NOT NULL,
	[BASIS] [VARCHAR](10) NULL,
	[DISPOSITION] [VARCHAR](32) NULL,
--	[EVENT] [varchar](300) NULL,
	[ITEM] [VARCHAR](32) NULL,
	[ITEM_NAME] [VARCHAR](256) NULL,
	[PRICE_TYPE] [VARCHAR](32) NULL,
	[PRICE_TYPE_NAME] [VARCHAR](128) NULL,
	[PRICE_LEVEL] [VARCHAR](10) NULL,
	[PRICE_LEVEL_NAME] [VARCHAR](128) NULL,
	[TICKET_PRICE] [NUMERIC](18, 2) NULL,
	[ORDER_DATE] [DATETIME] NULL,
	[ORDER_QTY] [BIGINT] NULL,
	[ORDER_AMT] [NUMERIC](38, 2) NULL,
	[Total_Paid] [NUMERIC](18, 2) NULL,
	[BALANCE_REMAINING] [NUMERIC](38, 2) NULL,
	[MINPMTDATE] [DATETIME] NULL,
	[ORIG_SALECODE] [VARCHAR](32) NULL,
	[ORIG_SALECODE_NAME] [VARCHAR](32) NULL,
	[PROMO] [VARCHAR](32) NULL,
	[PROMO_NAME] [VARCHAR](128) NULL,
	[MARK_CODE] [VARCHAR](32) NULL,
	[INREFSOURCE] [VARCHAR](128) NULL,
	[INREFDATA] [VARCHAR](128) NULL,
	[SEAT_BLOCK] [VARCHAR](8000) NULL,
	[ODET_EXPORT_DATETIME] [DATETIME] NULL,
	[ITEM_EXPORT_DATETIME] [DATETIME] NULL,
	PAYMENTPLAN VARCHAR(500),
	[maxchangedate] [DATETIME] NULL)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	
-- Select * from dbo.fn_APIView_Trans ( '704908' )
-- DECLARE @Customers VARCHAR(max) SET @Customers = '704908'
DECLARE @CustomerTbl TABLE (PatronIDs VARCHAR(50))

INSERT INTO @CustomerTbl
        ( [PatronIDs] )
SELECT value FROM dbo.[fn_Split](@Customers,',')

INSERT INTO @ReturnTable
SELECT 
	 tkOdet.SEASON 
	 , [tkSeason].[NAME] SEASONNAME
	,tkOdet.SEASON + ':' + tkOdet.ZID   ORDER_LINE_ID
	,tkOdet.SEQ		ORDER_SEQUENCE 
	,tkOdet.CUSTOMER
	,tkItem.BASIS
	,tkOdet.I_DISP DISPOSITION
	--, CAST(STUFF(
 --              (SELECT      ',' + EVENT  + ''
 --              FROM      TK_ODET AS subtkOdet JOIN TK_ODET_EVENT_ASSOC tkOdetEventAssoc ON 
	--						subtkOdet.SEASON = tkOdetEventAssoc.SEASON 
	--						AND subtkOdet.ZID  = tkOdetEventAssoc.ZID 
 --              WHERE      subtkOdet.ZID = tkOdet.ZID AND subtkOdet.SEASON = tkOdet.SEASON
	--		  --and subtkOdet.SEASON = 'F13'  
	--          FOR XML PATH('')), 1, 1, '') AS VARCHAR(300)) AS EVENT  
	,tkOdet.ITEM
	,[tkItem].[NAME] ITEM_NAME
	,tkOdet.I_PT PRICE_TYPE
	,[tkPriceType].[NAME] PRICE_TYPE_NAME
	,tkOdet.I_PL PRICE_LEVEL
	,tkPriceLevel.[PriceLevelFullName] PRICE_LEVEL_NAME
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
		
		ELSE ISNULL(PaidFinal.MINPMTDATE,'1900-01-01') END AS maxchangedate 	
--		INTO [dbo].[TI_SFDC_ODETOutput] 
-- SELECT *
FROM 
	TK_ODET tkOdet 
	JOIN TK_ITEM tkItem ON tkOdet.SEASON = tkItem.SEASON AND tkOdet.ITEM = tkItem.ITEM
	JOIN TK_SEASON tkSeason ON tkOdet.SEASON = tkSeason.SEASON
	LEFT JOIN [dbo].[vTK_PriceLevel] tkPriceLevel ON [tkOdet].[I_PL] = [tkPriceLevel].[PriceLevelCode] 
														AND [tkItem].[ITEM] = [tkPriceLevel].[ItemCode]
														AND [tkOdet].[SEASON] = [tkPriceLevel].[SeasonCode]
	LEFT JOIN dbo.[TK_PRTYPE] tkPriceType ON tkOdet.SEASON = tkPriceType.SEASON AND tkOdet.I_PT = tkPriceType.PRTYPE 
	LEFT JOIN [dbo].[TK_PROMO] tkPromo ON tkodet.[PROMO] = [tkPromo].[PROMO]
	LEFT JOIN dbo.TK_SALECODE SALECODE ON SALECODE.SALECODE = tkOdet.ORIG_SALECODE
	LEFT JOIN
(
		
SELECT
	tkTransItem.CUSTOMER
	,MIN(tkTrans.DATE) MINPMTDATE
	,tkTransItem.ITEM
	,tkTransItem.I_PT 
	,tkTransItem.SEASON 

FROM
	dbo.TK_TRANS tkTrans
	INNER JOIN dbo.TK_TRANS_ITEM tkTransItem ON tkTrans.Season = tkTransItem.Season AND tkTrans.Trans_No = tkTransItem.Trans_No
	INNER JOIN dbo.TK_TRANS_ITEM_PAYMODE tkTransItemPaymode ON tkTransItem.SEASON = tkTransItemPaymode.SEASON 
														AND tkTransItem.TRANS_NO = tkTransItemPaymode.TRANS_NO 
														AND tkTransItem.VMC = tkTransItemPaymode.VMC
	INNER JOIN  dbo.TK_ITEM tkItem ON tkTransItem.SEASON = tkItem.SEASON AND tkTransItem.ITEM = tkItem.ITEM
WHERE
     tkTransItemPaymode.I_PAY_TYPE = 'I'
GROUP BY
	 tkTransItem.CUSTOMER
	,tkTransItem.ITEM
	,tkTransItem.I_PT
	,tkTransItem.SEASON
HAVING SUM(ISNULL((tkTransItemPaymode.I_PAY_PAMT ),0)) > 0 
) PaidFinal ON 
		tkOdet.CUSTOMER = PaidFinal.CUSTOMER
	AND tkOdet.ITEM = PaidFinal.ITEM
	AND ISNULL(tkOdet.I_PT, 99999)  = ISNULL(PaidFinal.I_PT,99999) 
	AND tkOdet.SEASON = PaidFinal.SEASON 

WHERE 1=1
--AND [tkOdet].[CUSTOMER] = '704908'
AND tkOdet.[CUSTOMER] IN ( SELECT * FROM @CustomerTbl ) 
AND [tkOdet].[I_DATE] >= DATEAdd(DAY, -725, GETDATE())
--AND [tkPriceLevel].[PriceLevelFullName] IS NOT NULL

	RETURN 
END



GO
