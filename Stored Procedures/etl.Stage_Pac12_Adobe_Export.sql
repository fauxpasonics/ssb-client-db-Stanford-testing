SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [etl].[Stage_Pac12_Adobe_Export]
(
	@BatchId UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
	@Options NVARCHAR(max) = NULL
)

AS
BEGIN

TRUNCATE TABLE etl.DOMO_Pac12_Stanford_Adobe_TrackingLog
INSERT INTO etl.DOMO_Pac12_Stanford_Adobe_TrackingLog
EXEC [rpt].[DOMO_Pac12_Stanford_Adobe_TrackingLog]


TRUNCATE TABLE etl.DOMO_Pac12_Stanford_Adobe_Recipient
INSERT INTO etl.DOMO_Pac12_Stanford_Adobe_Recipient
EXEC [rpt].[DOMO_Pac12_Stanford_Adobe_Recipient]


TRUNCATE TABLE etl.DOMO_Pac12_Stanford_Adobe_FormSubmits
INSERT INTO etl.DOMO_Pac12_Stanford_Adobe_FormSubmits
EXEC [rpt].[DOMO_Pac12_Stanford_Adobe_FormSubmits]


TRUNCATE TABLE etl.DOMO_Pac12_Stanford_Adobe_Delivery
INSERT INTO etl.DOMO_Pac12_Stanford_Adobe_Delivery
EXEC [rpt].[DOMO_Pac12_Stanford_Adobe_Delivery]


TRUNCATE TABLE etl.DOMO_Pac12_Stanford_Adobe_DeliveryLog
INSERT INTO etl.DOMO_Pac12_Stanford_Adobe_DeliveryLog
EXEC [rpt].[DOMO_Pac12_Stanford_Adobe_DeliveryLog]

END

GO
