--1--
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN 
	SELECT 
	       FirstName,
		   LastName
	  FROM Employees
	 WHERE Salary > 35000 
END
GO

EXEC dbo.usp_GetEmployeesSalaryAbove35000
GO
--2--
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber(@Salary DECIMAL(18, 4))
AS
BEGIN
	SELECT 
		   FirstName,
		   LastName
	  FROM Employees
	 WHERE Salary >= @Salary
END
GO

EXEC dbo.usp_GetEmployeesSalaryAboveNumber 48100
GO

--3--
CREATE PROC usp_GetTownsStartingWith(@StartChar VARCHAR(50))
AS
BEGIN
	SELECT 
		   [Name] AS Town
	  FROM Towns
	 WHERE [Name] LIKE(@StartChar + '%')
END
GO

EXEC usp_GetTownsStartingWith 'b'
GO

--4--
CREATE PROC usp_GetEmployeesFromTown(@TownName VARCHAR(20))
AS
BEGIN
	SELECT
		   e.FirstName,
		   e.LastName
	  FROM Employees AS e
	  JOIN Addresses AS ad
	    ON ad.AddressID = e.AddressID
	  JOIN Towns AS t
	    ON t.TownID = ad.TownID
	   AND t.[Name] = @TownName
END

EXEC usp_GetEmployeesFromTown 'sofia'
GO
--5--
CREATE FUNCTION ufn_GetSalaryLevel(@Salary DECIMAL(18,4))
RETURNS VARCHAR(20)
BEGIN
	DECLARE @SalaryLevel VARCHAR(20) =
		CASE
		  WHEN @Salary < 30000 THEN 'Low'
		  WHEN @Salary BETWEEN 30000 AND 50000 THEN 'Average' 
		  WHEN @Salary > 50000 THEN 'High'
		END

	RETURN @SalaryLevel
END
GO

SELECT 
	   Salary,
	   dbo.ufn_GetSalaryLevel(Salary) AS SalaryLevel	
  FROM Employees
GO

--6--
CREATE PROC usp_EmployeesBySalaryLevel(@SalaryLevel VARCHAR(10))
AS
BEGIN
	SELECT 
	       FirstName,
		   LastName
	  FROM Employees
	 WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel
END

EXEC usp_EmployeesBySalaryLevel 'high'
GO

--7--
CREATE FUNCTION ufn_IsWordComprised(@SetOfLetters VARCHAR(50), @Word VARCHAR(50))
RETURNS BIT
BEGIN

  DECLARE @isComprised BIT = 0;
  DECLARE @currentIndex INT = 1;
  DECLARE @currentChar CHAR;

  WHILE(@currentIndex <= LEN(@word))
  BEGIN
    SET @currentChar = SUBSTRING(@word, @currentIndex, 1);
    IF(CHARINDEX(@currentChar, @setOfLetters) = 0)
      RETURN @isComprised;
    SET @currentIndex += 1;
  END
  RETURN @isComprised + 1;

	RETURN @IsComprised;
END
GO

CREATE TABLE TestDB (SetOfLetters varchar(max), Word varchar(max))
GO

INSERT INTO TestDB VALUES 
  ('oistmiahf', 'Sofia'), ('oistmiahf', 'halves'), ('bobr', 'Rob'), ('pppp', 'Guy'), ('', 'empty')
GO

SELECT
       SetOfLetters,
	   Word,
	   dbo.ufn_IsWordComprised(SetOfLetters, Word) AS Result
  FROM TestDB
GO

--8--


--9--
