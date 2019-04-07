--1--
SELECT TOP 5
	   e.EmployeeID,
	   e.JobTitle,
	   e.AddressID,
	   a.AddressText
  FROM Employees AS e
INNER JOIN Addresses AS a
    ON a.AddressID = e.AddressID
ORDER BY a.AddressID

--02--
SELECT TOP 50
	   e.FirstName,
	   e.LastName,
	   t.[Name] AS Town,
	   a.AddressText
  FROM Employees AS e
  JOIN Addresses AS a 
	ON a.AddressID = e.AddressID
  JOIN Towns AS t 
    ON t.TownID = a.TownID
ORDER BY e.FirstName, e.LastName

--3--
SELECT 
	   e.EmployeeID,
	   e.FirstName,
	   e.LastName,
	   d.[Name] AS DepartmentName
  FROM Employees AS e
  JOIN Departments AS d
    ON e.DepartmentID = d.DepartmentID
 WHERE d.[Name] = 'Sales'
ORDER BY e.EmployeeID

--4--
SELECT TOP 5
	   e.EmployeeID,
	   e.FirstName,
	   e.Salary,
	   d.[Name] AS DepartmentName
  FROM Employees AS e
  JOIN Departments AS d
    ON d.DepartmentID = e.DepartmentID
 WHERE e.Salary > 15000
ORDER BY d.DepartmentID

--5--
SELECT TOP 3
       e.EmployeeId,
	   e.FirstName
  FROM Employees AS e
  LEFT OUTER JOIN EmployeesProjects AS ep
    ON e.EmployeeID = ep.EmployeeID
 WHERE  ep.EmployeeID IS NULL
ORDER BY ep.EmployeeID

--6--
SELECT 
       e.FirstName,
	   e.LastName,
	   e.HireDate,
	   d.[Name] AS DeptName
  FROM Employees AS e
  JOIN Departments AS d
    ON d.DepartmentID = e.DepartmentID
 WHERE e.HireDate > '1/1/1999' 
   AND d.[Name] IN ('Sales', 'Finance')
ORDER BY e.HireDate

--7--
SELECT TOP 5
       e.EmployeeID,
	   e.FirstName,
	   p.[Name] AS ProjectName
  FROM Employees AS e
  JOIN EmployeesProjects AS ep
    ON e.EmployeeID = ep.EmployeeID 
  JOIN Projects AS p
    ON ep.ProjectID = p.ProjectID 
	AND p.StartDate > '2002/08/13' 
    AND p.EndDate IS NULL
ORDER BY e.EmployeeID 

--8--
SELECT 
       e.EmployeeID,
	   e.FirstName,
  CASE 
	   WHEN p.StartDate > '2005'
	   THEN NULL
	   ELSE p.[Name]
   END AS ProjectName
  FROM Employees AS e
  JOIN EmployeesProjects AS ep
    ON e.EmployeeID = ep.EmployeeID
  JOIN Projects AS p 
    ON p.ProjectID = ep.ProjectID
 WHERE e.EmployeeID = 24

 --9--
SELECT 
        e.EmployeeID,
		e.FirstName,
		e.ManagerID,
		e2.FirstName AS ManagerName
   FROM Employees AS e
   JOIN Employees AS e2
     ON e.ManagerID = e2.EmployeeID
  WHERE e.ManagerID IN (3,7)
ORDER BY e.EmployeeID

--10--
SELECT TOP 50
       e.EmployeeID,
	   e.FirstName + ' ' + e.LastName AS EmployeeName,
	   e2.FirstName + ' ' + e2.LastName AS ManagerName,
	   d.[Name] AS DepartmentName
  FROM Employees AS e
  JOIN Employees AS e2
    ON e.ManagerID = e2.EmployeeID
  JOIN Departments AS d
    ON d.DepartmentID = e.DepartmentID
ORDER BY e.EmployeeID

--11--
SELECT (MIN(e.AverageSalary))
  FROM (
	SELECT 
       AVG(Salary) AS AverageSalary
	  FROM Employees
  GROUP BY DepartmentID
	) AS e

SELECT * FROM Employees

--12--
SELECT 
	   c.CountryCode,
	   m.MountainRange,
	   p.PeakName,
	   p.Elevation
  FROM Countries AS c
  JOIN MountainsCountries AS mc
    ON mc.CountryCode = c.CountryCode
  JOIN Mountains AS m
    ON mc.MountainId = m.Id
  JOIN Peaks AS p
    ON p.MountainId = mc.MountainId
   AND p.Elevation > 2835
 WHERE c.CountryCode = 'BG'
ORDER BY p.Elevation DESC

--13--
SELECT 
	   c.CountryCode,
	   COUNT(mc.MountainId) AS MountainRanges
  FROM Countries AS c
  JOIN MountainsCountries AS mc
    ON c.CountryCode = mc.CountryCode
GROUP BY mc.CountryCode,
	   c.CountryCode,
	   c.CountryName
HAVING c.CountryCode IN ('BG', 'RU', 'US')

--14--
SELECT TOP 5
	   c.CountryName,
	   r.RiverName
  FROM Countries AS c
LEFT JOIN CountriesRivers AS cr
    ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers AS r
    ON r.Id = cr.RiverId
 WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName

--15--
SELECT ranked.ContinentCode,
       ranked.CurrencyCode,
       ranked.CurrencyUsage
FROM
(
    SELECT gbc.ContinentCode,
           gbc.CurrencyCode,
           gbc.CurrencyUsage,
           DENSE_RANK() OVER(PARTITION BY gbc.ContinentCode ORDER BY gbc.CurrencyUsage DESC) AS UsageRank
    FROM
    (
        SELECT ContinentCode,
               CurrencyCode,
               COUNT(CurrencyCode) AS CurrencyUsage
        FROM Countries
        GROUP BY ContinentCode,
                 CurrencyCode
        HAVING COUNT(CurrencyCode) > 1
    ) AS gbc
) AS ranked
WHERE ranked.UsageRank = 1
ORDER BY ranked.ContinentCode

--16--
SELECT 
	   COUNT(c.CountryCode) AS CountryCode
  FROM Countries AS c
 LEFT OUTER JOIN MountainsCountries AS mc
	ON c.CountryCode = mc.CountryCode
 WHERE mc.CountryCode IS NULL

--17--
SELECT TOP (5) peaks.CountryName,
               peaks.Elevation AS HighestPeakElevation,
               rivers.Length AS LongestRiverLength
FROM
(
    SELECT c.CountryName,
           c.CountryCode,
           DENSE_RANK() OVER(PARTITION BY c.CountryName ORDER BY p.Elevation DESC) AS DescendingElevationRank,
           p.Elevation
    FROM Countries AS c
         FULL OUTER JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
         FULL OUTER JOIN Mountains AS m ON mc.MountainId = m.Id
         FULL OUTER JOIN Peaks AS p ON m.Id = p.MountainId
) AS peaks
FULL OUTER JOIN
(
    SELECT c.CountryName,
           c.CountryCode,
           DENSE_RANK() OVER(PARTITION BY c.CountryCode ORDER BY r.Length DESC) AS DescendingRiversLenghRank,
           r.Length
    FROM Countries AS c
         FULL OUTER JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
         FULL OUTER JOIN Rivers AS r ON cr.RiverId = r.Id
) AS rivers ON peaks.CountryCode = rivers.CountryCode
WHERE peaks.DescendingElevationRank = 1
      AND rivers.DescendingRiversLenghRank = 1
      AND (peaks.Elevation IS NOT NULL
           OR rivers.Length IS NOT NULL)
ORDER BY HighestPeakElevation DESC,
         LongestRiverLength DESC,
         CountryName

--18--
SELECT TOP (5) jt.CountryName AS Country,
               ISNULL(jt.PeakName, '(no highest peak)') AS HighestPeakName,
               ISNULL(jt.Elevation, 0) AS HighestPeakElevation,
               ISNULL(jt.MountainRange, '(no mountain)') AS Mountain
FROM
(
    SELECT c.CountryName,
           DENSE_RANK() OVER(PARTITION BY c.CountryName ORDER BY p.Elevation DESC) AS PeakRank,
           p.PeakName,
           p.Elevation,
           m.MountainRange
    FROM Countries AS c
         LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
         LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
         LEFT JOIN Peaks AS p ON m.Id = p.MountainId
) AS jt
WHERE jt.PeakRank = 1
ORDER BY jt.CountryName,
         jt.PeakName;

--18--
SELECT TOP (5) jt.CountryName AS Country,
               CASE
                   WHEN jt.PeakName IS NULL
                   THEN '(no highest peak)'
                   ELSE jt.PeakName
               END AS HighestPeakName,
               CASE
                   WHEN jt.Elevation IS NULL
                   THEN 0
                   ELSE jt.Elevation
               END AS HighestPeakElevation,
               CASE
                   WHEN jt.MountainRange IS NULL
                   THEN '(no mountain)'
                   ELSE jt.MountainRange
               END AS Mountain
FROM
(
    SELECT c.CountryName,
           DENSE_RANK() OVER(PARTITION BY c.CountryName ORDER BY p.Elevation DESC) AS PeakRank,
           p.PeakName,
           p.Elevation,
           m.MountainRange
    FROM Countries AS c
         LEFT JOIN MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
         LEFT JOIN Mountains AS m ON mc.MountainId = m.Id
         LEFT JOIN Peaks AS p ON m.Id = p.MountainId
) AS jt
WHERE jt.PeakRank = 1
ORDER BY jt.CountryName,
         jt.PeakName;


  
	


	
   
  




