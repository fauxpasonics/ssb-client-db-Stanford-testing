SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[vTK_PriceLevel] as
select
	IT.Item						as ItemCode,
	isnull(nullif(left(PP.PL_Name,30),''),
		PP.PL)					as PriceLevel,
	PP.PL						as PriceLevelCode,
	PP.PL_Name					as PriceLevelFullName,
	IT.Season					as SeasonCode,
	IT.Season+'::'+IT.Item		as SeasonCodeItemCode,
	IT.Season+'::'+IT.Item+'::'+
		PP.PL					as SeasonCodeItemCodePrLevelCode,
	'('+IT.Season+'::'+IT.Item+') '+
		left(PP.PL_Name,30)
		collate SQL_Latin1_General_CP1_CS_AS
								as SeasonCodeItemCodePrLevel
From TK_Item(nolock)			as IT
	inner join TK_PTable_PRlev	as PP	on	PP.Season	= IT.Season
										and	PP.PTable	= IT.PTable


GO
