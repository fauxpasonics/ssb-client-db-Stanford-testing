SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





-- =============================================
-- Author:		<Abbey Meitin>
-- Create date: <11/15/2016>
-- Description:	<Created view to use in MDM Primary record selection>
-- =============================================


CREATE VIEW [src].[vwMDM_STH_SEATS] AS
(
SELECT  PATRON ,
        STH ,
        SEATS ,
		TRANS
FROM    dbo.PD_PATRON p WITH (NOLOCK)
        LEFT JOIN ( SELECT  MAX(MaxDate) STH ,
                            ETL__SSID_PATRON
                    FROM    ( SELECT    MAX(MinPaymentDate) MaxDate ,
                                        dtc.ETL__SSID_PATRON
                              FROM      [dbo].[FactTicketSales] rb WITH (NOLOCK)
										INNER JOIN dbo.DimSeason ds WITH (NOLOCK) ON rb.DimSeasonId = ds.DimSeasonId
										INNER JOIN [dbo].[DimItem] i WITH (NOLOCK) ON rb.DimItemID = i.DimItemId
										INNER JOIN dbo.DimTicketCustomer dtc WITH(NOLOCK) on rb.DimTicketCustomerId = dtc.DimTicketCustomerId
                              WHERE     ((LEFT(ds.seasoncode,1) = 'F' AND i.ItemClass = 'ST') --Football
										OR (LEFT(ds.seasoncode,1) = 'D' AND i.ItemClass = 'ST') -- Baseball
										OR (LEFT(ds.seasoncode,1) = 'B' AND i.ItemClass = 'ST') --Men's Basketball
										OR (LEFT(ds.seasoncode,2) = 'MS' AND i.ItemClass = 'ST') --Men's Soccer
										OR (LEFT(ds.seasoncode,1) = 'S' AND i.ItemClass = 'ST') --Soccer
										OR (LEFT(ds.seasoncode,1) = 'V' AND i.ItemClass = 'ST') --Women's Volleyball
										OR (LEFT(ds.seasoncode,1) = 'W' AND i.ItemClass = 'ST') --Women's Basketball
										OR (LEFT(ds.seasoncode,2) = 'WS' AND i.ItemClass = 'ST')) --Women's Soccer
								GROUP BY   dtc.ETL__SSID_PATRON
                            ) x
							 GROUP BY x.ETL__SSID_PATRON
                  ) sth ON p.PATRON = sth.ETL__SSID_PATRON
				 
        LEFT JOIN ( SELECT  CUSTOMER ,
                            COUNT(SEAT) SEATS
                    FROM    dbo.TK_SEAT_SEAT tkSeatSeat WITH (NOLOCK)
					WHERE CAST(RIGHT(tkSeatSeat.season,2) AS INT)
							>= RIGHT(DATEPART(YEAR,GETDATE()),2)-4
                    GROUP BY CUSTOMER
                  ) seats ON p.PATRON = seats.CUSTOMER
LEFT JOIN (
SELECT MAX(date) TRANS, customer FROM dbo.tk_trans WITH (NOLOCK) GROUP BY customer ) trans ON p.patron = trans.customer


)



GO
