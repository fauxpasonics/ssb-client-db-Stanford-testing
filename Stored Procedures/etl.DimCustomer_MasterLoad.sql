SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [etl].[DimCustomer_MasterLoad]

AS
BEGIN


-- TI
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Stanford', @LoadView = 'etl.vw_Load_DimCustomer_TI', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

-- SFDC
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Stanford', @LoadView = 'etl.vw_Load_DimCustomer_SFDCAccount', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'


-- Adobe
EXEC mdm.etl.LoadDimCustomer @ClientDB = 'Stanford', @LoadView = '[etl].[vw_Load_DimCustomer_Adobe]', @LogLevel = '0', @DropTemp = '1', @IsDataUploaderSource = '0'

--SFDC deletes
UPDATE b
	SET b.IsDeleted = a.IsDeleted
	,deletedate = getdate()
	--SELECT a.IsDeleted
	--SELECT COUNT(*) 
	FROM Stanford_Reporting.ProdCopy.Account a (NOLOCK)
	INNER JOIN dbo.DimCustomer b (NOLOCK) ON a.id = b.SSID AND b.SourceSystem = 'Stanford PC_SFDC Account'
	WHERE a.IsDeleted <> b.IsDeleted

--Paciolan Deletes (Added 1/16/2018 by AMEITIN)

UPDATE dc
	SET IsDeleted = '1'
	, DeleteDate = GETUTCDATE()
	FROM dbo.DimCustomer dc (NOLOCK)
	LEFT JOIN (select DISTINCT PATRON
				FROM dbo.PD_PATRON (NOLOCK)) p on dc.SourceSystem = 'Stanford_TI' AND dc.SSID = p.PATRON
	WHERE p.PATRON IS NULL
	AND SourceSystem = 'Stanford_TI'
	AND dc.IsDeleted = '0'

END



GO
