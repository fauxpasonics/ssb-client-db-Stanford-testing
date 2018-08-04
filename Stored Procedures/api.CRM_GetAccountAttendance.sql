SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO











--EXEC [api].[CRM_GetAccountAttendance] @SSB_CRMSYSTEM_ACCT_ID = 'D2C2E97F-6D6A-4194-971F-6E4E36046D68'
--EXEC [api].[CRM_GetAccountAttendance] @SSB_CRMSYSTEM_CONTACT_ID = 'E7FDCDC8-1C5E-425A-8202-60A12ED75EEA'

CREATE PROCEDURE [api].[CRM_GetAccountAttendance]
      @SSB_CRMSYSTEM_ACCT_ID VARCHAR(50) = 'Test',
	  @SSB_CRMSYSTEM_CONTACT_ID VARCHAR(50) = 'Test',
	  @DisplayTable INT = 0,
	  @RowsPerPage  INT = 500, @PageNumber   INT = 0
AS
    BEGIN


-- Init vars needed for API
DECLARE @totalCount         INT,
	@xmlDataNode        XML,
	@recordsInResponse  INT,
	@remainingCount     INT,
	@rootNodeName       NVARCHAR(100),
	@responseInfoNode   NVARCHAR(MAX),
	@finalXml           XML

PRINT 'Acct-' + @SSB_CRMSYSTEM_ACCT_ID
PRINT 'Contact-' + @SSB_CRMSYSTEM_CONTACT_ID

DECLARE @GUIDTable TABLE (
GUID VARCHAR(50)
)

IF (@SSB_CRMSYSTEM_ACCT_ID NOT IN ('None','Test'))
BEGIN
	INSERT INTO @GUIDTable
	        ( GUID )
	SELECT DISTINCT z.SSB_CRMSYSTEM_CONTACT_ID
		FROM dbo.vwDimCustomer_ModAcctId z 
		WHERE z.SSB_CRMSYSTEM_ACCT_ID = @SSB_CRMSYSTEM_ACCT_ID
END

IF (@SSB_CRMSYSTEM_CONTACT_ID NOT IN ('None','Test'))
BEGIN
	INSERT INTO @GUIDTable
	        ( GUID )
	SELECT @SSB_CRMSYSTEM_CONTACT_ID
END


SELECT DimCustomer.SSB_CRMSYSTEM_ACCT_ID
	  ,Season_Name
	  ,Event_Code
	  ,Event_Name
	  ,Event_Date
	  ,Event_Time
	  ,Section_Name
	  ,Row_Name
	  ,Seat
	  ,Scan_Time
	  ,Game_Scan_Time_Difference
	  ,Scan_Gate
	  ,IsAttended
INTO #tmpbase
FROM (  SELECT tkSeatSeat.CUSTOMER
				, Season.NAME AS Season_Name
				, tkSeatSeat.Event AS Event_code
				, Event.NAME AS Event_Name
				, Event.DATE AS Event_Date
				, CASE WHEN Event.time = 'TBA' THEN '1900-01-01'
					   WHEN Event.TIME <> 'TBA' THEN CAST(Event.time AS TIME) END AS Event_Time
				, tkSeatSeat.SECTION AS Section_Name
				, tkSeatSeat.ROW AS Row_Name
				, tkSeatSeat.SEAT AS Seat
				, CAST(bc.SCAN_TIME AS TIME) Scan_Time
				, DATEDIFF(MINUTE,(CASE WHEN Event.time = 'TBA' THEN '1900-01-01'
									 WHEN Event.TIME <> 'TBA' THEN CAST(Event.time AS TIME) END),bc.SCAN_TIME) Game_Scan_Time_Difference
				, bc.SCAN_GATE AS Scan_Gate
				, CASE WHEN bc.ATTENDED = 'Y' THEN 1
							ELSE 0 END AS IsAttended
			FROM dbo.TK_SEAT_SEAT tkSeatSeat WITH (NOLOCK)
			JOIN dbo.TK_SEASON Season WITH (NOLOCK) ON Season.SEASON = tkSeatSeat.SEASON
			JOIN dbo.TK_EVENT Event WITH (NOLOCK) ON Event.SEASON = tkSeatSeat.SEASON AND Event.EVENT = tkSeatSeat.EVENT
			LEFT JOIN dbo.TK_BC bc ON bc.BC_ID = tkSeatSeat.BARCODE AND bc.SEASON = tkSeatSeat.SEASON
			WHERE Event.DATE <= CAST(GETDATE()+1 AS DATE)
					 )x
	  INNER JOIN [dbo].[vwDimCustomer_ModAcctId] DimCustomer WITH ( NOLOCK ) ON DimCustomer.SSID = x.CUSTOMER
																   AND DimCustomer.SourceSystem = 'Stanford_TI'
WHERE ISNULL([DimCustomer].[SSB_CRMSYSTEM_ACCT_ID],DimCustomer.[SSB_CRMSYSTEM_CONTACT_ID]) IN (SELECT GUID FROM @GUIDTable) AND YEAR(x.Event_Date)>= YEAR(GETDATE())-3

SELECT  ISNULL(Season_Name, '') Season_Name ,
        ISNULL(Event_Code, '') Event_Code ,
        ISNULL(Event_Name, '') Event_Name ,
        ISNULL(Event_Date, '') Event_Date ,
        ISNULL(CONVERT(VARCHAR(15), Event_Time, 0), '') Event_Time ,
        ISNULL(CONVERT(VARCHAR(15), Scan_Time, 0), '') Scan_Time ,
        ( CASE WHEN IsAttended = 1 THEN Game_Scan_Time_Difference
               ELSE NULL
          END ) True_GameScanDiff ,
        ISNULL(CAST(LTRIM(RTRIM(STR(ABS(CASE WHEN IsAttended = 1
                                             THEN Game_Scan_Time_Difference
                                             ELSE NULL
                                        END)))) + ' minute'
               + CASE WHEN Game_Scan_Time_Difference = 0 THEN ''
                      ELSE 's'
                 END + CASE WHEN Game_Scan_Time_Difference < 0 THEN ' early'
                            ELSE ' late'
                       END AS VARCHAR(50)), '') Game_Scan_Time_Difference ,
        ISNULL(Scan_Gate, '') Scan_Gate ,
        ISNULL(IsAttended, '') IsAttended ,
        ISNULL(Section_Name, '') Section_Name ,
        ISNULL(Row_Name, '') Row_Name ,
        ISNULL(Seat, '') Seat
INTO    #tmpOutput
FROM    #tmpbase
ORDER BY Event_Date ,
        Row_Name ASC ,
        Seat ASC
        OFFSET ( @PageNumber ) * @RowsPerPage ROWS
FETCH NEXT @RowsPerPage ROWS ONLY



SELECT CAST(Season_Name AS VARCHAR(50)) Season_Name
, COUNT(CASE WHEN Event_Date <= GETDATE() THEN Event_Code ELSE NULL END) Total_Available
, SUM(CAST(IsAttended AS INT)) Total_Attended
, ISNULL(
			CAST(CAST(
				(SUM(CAST(IsAttended AS INT)) / CAST(NULLIF(COUNT(CASE WHEN Event_Date <= GETDATE() THEN Event_Code ELSE NULL END),0) AS float))*100 
				AS DECIMAL(18,1)) 
			AS VARCHAR(50)) + '%','') [Percent_Attended]
, ISNULL(LTRIM(RTRIM(STR(ABS(AVG(CASE WHEN IsAttended = 1 THEN Game_Scan_Time_Difference ELSE NULL END))))) + ' minute' 
		+ CASE WHEN AVG(CASE WHEN IsAttended = 1 THEN Game_Scan_Time_Difference ELSE NULL END) = 0 THEN '' ELSE 's' END 
		+ CASE WHEN AVG(CASE WHEN IsAttended = 1 THEN Game_Scan_Time_Difference ELSE NULL END) < 0 THEN ' early' ELSE ' late' END,'') Avg_Scan_Time
INTO #tmpParent
FROM #tmpBase
GROUP BY CAST(Season_Name AS VARCHAR(50))
-- DROP TABLE #tmpParent

-- Pull counts
SELECT @recordsInResponse = COUNT(*) FROM #tmpOutput
SELECT @totalCount = COUNT(*) FROM #tmpBase

SET @xmlDataNode = (
		SELECT * ,
			(
            SELECT  a.Season_Name ,
                    a.Event_Code ,
                    a.Event_Name ,
                    a.Event_Date ,
                    a.Event_Time ,
                    a.Scan_Time ,
                    a.Game_Scan_Time_Difference ,
                    a.Scan_Gate ,
                    a.Section_Name ,
                    a.Row_Name ,
                    a.Seat 
            FROM    #tmpOutput a
            WHERE   a.Season_Name = p.Season_Name
            ORDER BY Event_Date 
            FOR     XML PATH('Child') ,
                        TYPE
			) AS 'Children'                
		FROM #tmpParent p
		ORDER BY p.Season_Name DESC
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

	PRINT @responseInfoNode
	
-- Wrap response info and data, then return	
IF @xmlDataNode IS NULL
BEGIN
	SET @xmlDataNode = '<' + @rootNodeName + ' />' 
END
		
SET @finalXml = '<Root>' + @responseInfoNode + CAST(@xmlDataNode AS NVARCHAR(MAX)) + '</Root>'

IF @DisplayTable = 1
SELECT * FROM #tmpBase

IF @DisplayTable = 0
SELECT CAST(@finalXml AS XML)

DROP TABLE #tmpBase
DROP TABLE #tmpOutput
DROP TABLE #tmpParent
        
    END
























GO
