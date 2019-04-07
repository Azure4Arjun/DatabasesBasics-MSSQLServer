--1--
SELECT FirstName, LastName 
FROM Employees
WHERE FirstName LIKE('SA%')

--2--
SELECT FirstName, LastName 
FROM Employees
WHERE LastName LIKE('%ei%')

--3--
SELECT FirstName 
FROM Employees
WHERE DATEPART(YEAR, HireDate) BETWEEN 1995 AND 2005 AND DepartmentID IN(3, 10) 

--4--
SELECT FirstName, LastName
FROM Employees
WHERE JobTitle NOT LIKE ('%Engineer%')

--5--
SELECT [Name]
FROM Towns
WHERE LEN(Name) IN(5, 6)
ORDER BY Name

--6--
SELECT TownId, [Name] 
FROM Towns
WHERE [Name] LIKE('[mkbe]%')
ORDER BY [Name] 

--7--
SELECT TownId, [Name] 
FROM Towns
WHERE LEFT([Name], 1) <> 'D' AND
	  LEFT([Name], 1) <> 'R' AND
	  LEFT([Name], 1) <> 'B'
ORDER BY [Name] 
 
 --Other solution--

SELECT TownId, [Name] 
FROM Towns
WHERE [Name] NOT LIKE('[rdb]%')
ORDER BY [Name] 

GO

--8--
CREATE VIEW V_EmployeesHiredAfter2000 AS
SELECT FirstName, LastName 
FROM Employees
WHERE DATEPART(YEAR, HireDate) > 2000

GO

--9--
SELECT FirstName, LastName
FROM Employees
WHERE LEN(LastName) = 5	  

--10--
SELECT EmployeeID, FirstName, LastName, Salary,
DENSE_RANK() OVER (PARTITION BY Salary ORDER BY	EmployeeID) 'Rank'
FROM Employees 
WHERE Salary BETWEEN 10000 AND 50000 
ORDER BY Salary DESC

--11--
SELECT * 
	FROM(
		SELECT EmployeeID, FirstName, LastName, Salary,
		DENSE_RANK() OVER (PARTITION BY Salary ORDER BY	EmployeeID) AS 'Rank'
		FROM Employees
		) D
	WHERE Rank = 2 AND Salary BETWEEN 10000 AND 50000
	ORDER BY Salary DESC

--12--
SELECT CountryName, IsoCode
	FROM Countries
	WHERE LEN(CountryName) - LEN(REPLACE(CountryName, 'a', '')) >= 3
	ORDER BY IsoCode

--other solution--

SELECT CountryName, IsoCode
	FROM Countries
	WHERE CountryName LIKE '%a%a%a%'
	ORDER BY IsoCode

--13--
SELECT PeakName, RiverName, LOWER(PeakName + SUBSTRING(RiverName, 2, LEN(RiverName))) AS Mix
	FROM Peaks, Rivers
	WHERE RIGHT(PeakName, 1) = LEFT(RiverName, 1)
	ORDER BY Mix