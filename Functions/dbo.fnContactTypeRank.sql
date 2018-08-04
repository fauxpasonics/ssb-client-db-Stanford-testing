SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE FUNCTION [dbo].[fnContactTypeRank]
(
	@ContactClass CHAR(1) --A (Address), P (Phone), E(Email)
)

RETURNS @Result TABLE 
(  
	ContactType	VARCHAR(25),
    PriorityRank INT
) 
AS
BEGIN

	IF (@ContactClass = 'A')
	BEGIN

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('M', 1)

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('B', 2)

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('S', 3)

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('O', 4)
		
	END	

	ELSE IF (@ContactClass = 'P')
	BEGIN

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('P', 1)

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('H', 2)

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('B', 3)

	END

	ELSE IF (@ContactClass = 'E')
	BEGIN

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('E', 1)

		INSERT INTO @Result (ContactType, PriorityRank)
		VALUES ('OE', 2)



	END


	RETURN

END









GO
