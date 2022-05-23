SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[toProperCase]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
-- =============================================
-- Author: ABC - Sean Austin
-- Create date: 29/12/2021
-- Description:	Returns the value of the @initialValue input parameter in the Proper case (First Letter Of Each Word Capitalized)
-- SELECT dbo.toProperCase(''petrol'') { Returns ''Petrol''}
-- =============================================
CREATE FUNCTION [dbo].[toProperCase]
(
    @initialValue VARCHAR(8000)
)
RETURNS VARCHAR(8000)  
AS
BEGIN
	DECLARE @caseFlag BIT; 
	DECLARE @ReturnValue VARCHAR(8000);
	DECLARE @idx INT;
	DECLARE @character CHAR(1);

	-- Capture Null Parameter Value
	IF @initialValue IS NULL
		RETURN NULL;

	-- Initialize
	SELECT @caseFlag = 1, @idx = 1, @ReturnValue = '''';
	-- Iterate through the characters one by one
	WHILE (@idx <= LEN(@initialValue))
		-- Get current character specified by @idx and concatonate charater to the end of @ReturnValue, the case depends on the current value of @caseFlag
		-- @caseFlag - Expression ''[a-zA-Z]'' - when used below {@character LIKE ''[a-zA-Z]''} a case change will only be performed when the character does not satisfy the expression, (i.e) a space.
		SELECT @character = SUBSTRING(@initialValue, @idx, 1),
		@ReturnValue = @ReturnValue + CASE WHEN @caseFlag = 1 THEN UPPER(@character) ELSE LOWER(@character) END,
		@caseFlag = CASE WHEN @character LIKE ''[a-zA-Z]'' THEN 0 ELSE 1 END,
		@idx = @idx + 1
	RETURN @ReturnValue 


END
' 
END