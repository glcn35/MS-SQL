
--Assignment-5

--Factorial Function
--Create a scalar-valued function that returns the factorial of a number you gave it.


CREATE FUNCTION udf_fact
(@fact INT)  

RETURNS INT 
BEGIN		
		DECLARE @input INT, @counter INT, @sonuc INT

		SET @input = @fact-- @input = 5--
		SET @counter = 1
		SET @sonuc =1

		while @counter <= @input
			BEGIN
				set @sonuc =@sonuc*@counter
				set @counter = @counter + 1	 
			END
		--print @sonuc
return @sonuc
END


SELECT dbo.udf_fact(6) as Fact_func


--ÖMER HOCANIN ÇÖZÜMÜ
-- Creating the scalar function
--CREATE FUNCTION dbo.Factorial ( @Number int )
--RETURNS INT
--AS
--BEGIN
--	DECLARE @i  int
--		IF @Number <= 1
--			SET @i = 1
--		ELSE
--			SET @i = @Number * dbo.Factorial( @Number - 1 )
--	RETURN (@i)
--END
--​
---- Calling the scalar function
--SELECT dbo.factorial(7)