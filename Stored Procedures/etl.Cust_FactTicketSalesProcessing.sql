SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE PROCEDURE [etl].[Cust_FactTicketSalesProcessing]
(
	@BatchId INT = 0,
	@LoadDate DATETIME = NULL,
	@Options NVARCHAR(MAX) = NULL
)
AS



BEGIN



/*****************************************************************************************************************
													TICKET TYPE
******************************************************************************************************************/



--  ============================================================================
--  Season Ticket Membership
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'ST'


--  ============================================================================
--  Mini Plan
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 4
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'MP'


--  ============================================================================
--  Flex Voucher Plan
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'FV'

--  ============================================================================
--  Single Event
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'SE'


--  ============================================================================
--  StubHub
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 7
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'SH'

--  ============================================================================
--  Away
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 8
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'A'


--  ============================================================================
--  Poastseason
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 9
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'PS'

--  ============================================================================
--  Priority Seat Gift
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 10
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'PSGIFT'

--  ============================================================================
--  Donation
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 11
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'DON'

--  ============================================================================
--  Gift Back
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 12
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'GB'

--  ============================================================================
--  Deposit
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 13
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'DEP'

--  ============================================================================
--  Exchange
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 14
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'EXCH'

--  ============================================================================
--  Season Ticket Add-on Request
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 15
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'STADD'

--  ============================================================================
--  Season Ticket Relocation Request
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 16
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'STRELO'

--  ============================================================================
--  Season Parking Add-on Request
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 17
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'PARKADD'

--  ============================================================================
--  Season Parking Relocation Request
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 18
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'PARKRELO'

--  ============================================================================
--  Group Tailgate
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 19
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'TG'

--  ============================================================================
--  Parking
--  ============================================================================

UPDATE fts
SET fts.DimTicketTypeId = 20
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'PARK'

--  ============================================================================
--  Beach Volleyball
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 21
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'BV'

--  ============================================================================
--  Cross Country
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 22
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'XC'

--  ============================================================================
--  Field Hockey
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 23
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'FH'

--  ============================================================================
--  Men's Gymnastics
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 24
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'MG'

--  ============================================================================
--  Men's Rowing
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 25
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'MROW'

--  ============================================================================
--  Men's Volleyball
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 26
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'MVB'

--  ============================================================================
--  Men's Water Polo
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 27
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'MWP'

--  ============================================================================
--  Rugby
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 28
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'RUGBY'

--  ============================================================================
--  Softball
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 29
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'SB'

--  ============================================================================
--  Synchronized Swimming
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 30
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'SYNCHRO'

--  ============================================================================
--  Track & Field
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 31
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'TF'

--  ============================================================================
--  Women's Gymnastics
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 32
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'WG'

--  ============================================================================
--  Women's Lacrosse
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 33
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'WL'

--  ============================================================================
--  Women's Water Polo
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 34
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'WWP'

--  ============================================================================
--  Wrestling
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 35
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'WR'

--  ============================================================================
--  Women's Rowing
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 36
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'WROW'

--  ============================================================================
--  Team Cardinal
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 37
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'TC'

--  ============================================================================
--  Gift Certificate
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 38
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'GC'

--  ============================================================================
--  Access Pass
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 39
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'AP'

--  ============================================================================
--  Miscellaneous Items
--  ============================================================================
UPDATE fts
SET fts.DimTicketTypeId = 40
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimItem di ON fts.DimItemId = di.DimItemId
WHERE di.ItemClass = 'MISC'

--------------------------------------------------------------------------------------------------------------------------------------------------

/*****************************************************************************************************************
													PLAN TYPE
******************************************************************************************************************/

--  ============================================================================
--  New Plan
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 1
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'STN'

--  ============================================================================
--  Add-on Plan
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 2
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'STA'

--  ============================================================================
--  Renewed Plan
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'ST'

--  ============================================================================
--  Group
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 4
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'G'

--  ============================================================================
--  Student
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'S'

--  ============================================================================
--  Opponent ------------------------------------------------------------------------------------ COME BACK TO THIS ONE 
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimCustomer d ON d.DimCustomerId = fts.DimTicketCustomerId
WHERE d.CustomerType IN ('O', 'V')


--  ============================================================================
--  StubHub Season Ticket
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 7
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'SHST'

--  ============================================================================
--  StubHub Mini Plan
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 8
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'SHMP'

--  ============================================================================
--  StubHub Ticket
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 9
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'SHT'

--  ============================================================================
--  StubHub Parking
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 10
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'PARKSH'

--  ============================================================================
--  Season Parking
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 11
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'PARKST'

--  ============================================================================
--  Single Game Parking
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 12
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'PARK'

--  ============================================================================
--  Transfer Season Parking
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 13
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'PARKTR'

--  ============================================================================
--  Transfer Season Ticket
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 14
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'TRST'

--  ============================================================================
--  Transfer Mini Plan
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 15
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'TRMP'

--  ============================================================================
--  Transfer Single Ticket
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 16
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'TR'

--  ============================================================================
--  Exchange Season Ticket
--  ============================================================================

UPDATE fts
SET fts.DimPlanTypeId = 17
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceType dpt ON dpt.DimPriceTypeId = fts.DimPriceTypeId
WHERE dpt.PriceTypeClass = 'EXCH'

-------------------------------------------------------------------------------------------------------------------------------------------------------

/*****************************************************************************************************************
													SEAT TYPE
******************************************************************************************************************/


--  ============================================================================
--  Premium Football
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '10'
AND (dl.Season = 'F14' OR dl.Season = 'F15')

UPDATE fts
SET fts.DimSeatTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('12','13','14')
AND dl.Season = 'F16'

UPDATE fts
SET fts.DimSeatTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('13', '15', '16')
AND dl.Season = 'F17'


--  ============================================================================
--  Premium Men's Basketball
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '6'
AND dl.Season = 'B14'

UPDATE fts
SET fts.DimSeatTypeId = 3
FROM    dbo.FactTicketSales fts 
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '1'
AND dl.Season IN ('B15', 'B16', 'B17')

--  ============================================================================
--  Premium Women's Basketball
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '5'
AND dl.Season = 'W14'

UPDATE fts
SET fts.DimSeatTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '1'
AND dl.Season IN ('W15', 'W16', 'W17')

--  ============================================================================
--  Premium Women's Volleyball
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '3'
AND dl.Season = 'V14'

UPDATE fts
SET fts.DimSeatTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '1'
AND dl.Season IN ('V15', 'V16')

--  ============================================================================
--  Premium Baseball
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '3'
AND dl.PTable = 'DS'
AND dl.Season IN ('D14', 'D15')

UPDATE fts
SET fts.DimSeatTypeId = 3
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '4'
AND dl.Season = 'D16'

--  ============================================================================
--  Priority Football
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 4
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('1','2')
AND dl.Season IN ('F14', 'F15', 'F16')

UPDATE fts
SET fts.DimSeatTypeId = 4
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('1','2','3','4','5','6')
AND dl.Season = 'F17'

--  ============================================================================
--  Priority Men's Basketball
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 4
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '1'
AND dl.Season = 'B14'

UPDATE fts
SET fts.DimSeatTypeId = 4
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '2'
AND (dl.Season = 'B15' OR dl.Season = 'B16')

UPDATE fts
SET fts.DimSeatTypeId = 4
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('2','3','4','5')
AND dl.Season = 'B17'

--  ============================================================================
--  Reserved Football
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('3','4','5','6','7')
AND dl.Season IN ('F14', 'F15', 'F16')

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('7','8','9','10')
AND dl.Season = 'F17'

--  ============================================================================
--  Reserved Men's Basketball
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('2','3')
AND dl.Season = 'B14'

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('3','4')
AND dl.Season IN ('B15', 'B16')

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('6','7')
AND dl.Season = 'B17'

--  ============================================================================
--  Reserved Women's Basketball
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('1','2')
AND dl.Season = 'W14'

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('2','3')
AND dl.Season IN ('W15', 'W16', 'W17')

--  ============================================================================
--  Reserved Women's Volleyball
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('1','5')
AND dl.Season = 'V14'

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '2'
AND dl.Season IN ('V15', 'V16')

--  ============================================================================
--  Reserved Women's Soccer
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode  = '1'
AND dl.Season IN ('S14', 'S16', 'WS15')

--  ============================================================================
--  Reserved Men's Soccer
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode  = '1'
AND dl.Season IN ('S14', 'S16', 'MS15')

--  ============================================================================
--  Reserved Baseball
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 5
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('1','2')
AND dl.Season IN ('D14', 'D15', 'D16')

--  ============================================================================
--  General Admission Football
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('8','9')
AND dl.Season IN ('F14', 'F15', 'F16')

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('11','12')
AND dl.Season = 'F17'

--  ============================================================================
--  General Admission Men's Basketball
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('4','5')
AND dl.Season = 'B14'

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('5','6')
AND dl.Season IN ('B15', 'B16')

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('8','9')
AND dl.Season = 'B17'

--  ============================================================================
--  General Admission Women's Basketball
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('3','4')
AND dl.Season = 'W14'

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('4','5')
AND dl.Season IN ('W15', 'W16', 'W17')

--  ============================================================================
--  General Admission Women's Volleyball
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '2'
AND dl.Season = 'V14'

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '3'
AND dl.Season IN ('V15', 'V16')

--  ============================================================================
--  General Admission Women's Soccer
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('2','3')
AND dl.Season IN ('S14', 'S16')


UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '2'
AND dl.Season = 'WS15'

--  ============================================================================
--  General Admission Men's Soccer
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode IN ('2','3')
AND dl.Season IN ('S14', 'S16')

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '2'
AND dl.Season = 'MS15'

--  ============================================================================
--  General Admission Baseball
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '3'
AND dl.Season IN ('D14', 'D15')
AND PTable <> 'DS'

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '3'
AND dl.Season = 'D16'

--  ============================================================================
--  General Admission Tennis
--  ============================================================================

UPDATE fts
SET fts.DimSeatTypeId = 6
FROM    dbo.FactTicketSales fts
        INNER JOIN dbo.DimPriceLevel dl ON dl.DimPriceLevelId = fts.DimPriceLevelId
WHERE dl.PriceLevelCode = '2'
AND dl.Season IN ('T14', 'T15', 'T16')

END 























GO
