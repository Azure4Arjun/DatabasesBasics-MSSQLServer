--5 Trips
SELECT 
	   Origin,
	   Destination
  FROM Flights
ORDER BY Origin, Destination

--6 The 'Tr' Planes
SELECT 
	   Id,
	   [Name],
	   Seats,
	   [Range]
  FROM Planes
 WHERE [Name] LIKE ('%tr%')
ORDER BY Id, [Name], Seats, [Range]

--7 Flight Profits
SELECT 
       f.Id AS FlightId,
	   SUM(t.Price) AS Price
  FROM Tickets AS t
  JOIN Flights AS f 
    ON t.FlightId = f.Id
GROUP BY t.FlightId, f.Id
ORDER BY Price DESC, FlightId


--8 Passengers and Prices
SELECT TOP(10) 
	   p.FirstName, 
			   p.LastName, 
			   t.Price 
  FROM Passengers AS p
  JOIN Tickets AS t
    ON t.PassengerId = p.Id
ORDER BY t.Price DESC, p.FirstName, p.LastName

--9 Most Used Luggages's
SELECT 
	   [Type],
	   COUNT(l.Id) AS MostUsed
  FROM LuggageTypes AS lt
  JOIN Luggages AS l
    ON l.LuggageTypeId = lt.Id
GROUP BY l.LuggageTypeId, lt.Id, lt.[Type]
ORDER BY MostUsed DESC, lt.[Type]

--10 Passenger Trips
SELECT 
	   p.FirstName + ' ' + p.LastName AS [Full Name], 
	   f.Origin, 
	   f.Destination
  FROM Passengers AS p
  JOIN Tickets AS t 
    ON t.PassengerId = p.Id
  JOIN Flights AS f
    ON f.Id = t.FlightId
ORDER BY [Full Name], Origin, Destination

--11 Non Adventures People
SELECT
	   p.FirstName, 
	   p.LastName, 
	   p.Age 
  FROM Passengers AS p
LEFT JOIN Tickets AS t
    ON t.PassengerId = p.Id
WHERE t.Id IS NULL
ORDER BY Age DESC, FirstName, LastName

--12 Lost Luggage's
SELECT 
	   p.PassportId AS [Passport Id] , 
	   p.[Address]
  FROM Passengers AS p
LEFT JOIN Luggages AS l 
    ON l.PassengerId = p.Id
 WHERE l.Id IS NULL
ORDER BY p.PassportId, p.[Address]

--13 Count of Trips
SELECT 
       p.FirstName,
	   p.LastName,
	   COUNT(t.PassengerId) AS TotalTrips
  FROM Passengers AS p
LEFT JOIN Tickets AS t
    ON p.Id = t.PassengerId
GROUP BY p.FirstName, p.LastName
ORDER BY TotalTrips DESC, p.FirstName, p.LastName

--14 Full Info
SELECT 
       p.FirstName + ' ' + p.LastName AS [Full name],
       pl.[Name] AS [Plane Name],
       f.Origin + ' - ' + f.Destination AS [Trip],
       lt.[Type] AS [LuggageType]
  FROM Passengers AS p
  JOIN Tickets AS t
    ON t.PassengerId = p.Id
  JOIN Luggages AS l
    ON l.Id = t.LuggageId
  JOIN LuggageTypes AS lt
    ON lt.Id = l.LuggageTypeId
  JOIN Flights AS f
    ON f.Id = t.FlightId
  JOIN Planes AS pl
    ON pl.Id = f.PlaneId
ORDER BY [Full name], 
		 pl.[Name], 
		 f.Origin, 
		 f.Destination, 
		 LuggageType

--15
SELECT 
	   k.FirstName, 
	   k.LastName, 
	   k.Destination, 
	   k.Price 
  FROM 
		(SELECT 
			    p.FirstName, 
				p.LastName, 
				f.Destination, 
				t.Price,
		DENSE_RANK() 
		OVER (PARTITION BY 
				p.FirstName, 
				p.LastName
		ORDER BY t.Price DESC) AS RowNumber
  FROM Passengers AS p
  JOIN Tickets AS t
    ON t.PassengerId = p.Id
  JOIN Flights AS f
    ON f.Id = t.FlightId) AS k
 WHERE k.RowNumber = 1
ORDER BY k.Price DESC, 
	     k.FirstName, 
		 k.LastName, 
		 k.Destination

--16 Destination Info
SELECT f.Destination, COUNT(FlightId) AS [FilesCount]
  FROM Flights AS f
LEFT JOIN Tickets AS t
    ON t.FlightId = f.Id
GROUP BY f.Destination
ORDER BY COUNT(FlightId) DESC, f.Destination

--17 PSP
SELECT 
	   pl.[Name],
	   pl.Seats,
	   COUNT(p.Id) AS Passengers
  FROM Passengers AS p
RIGHT  JOIN Tickets AS t
    ON p.Id = t.PassengerId
RIGHTJOIN Flights  AS f
    ON t.FlightId = f.Id
RIGHT JOIN Planes AS pl
    ON f.PlaneId = pl.Id
GROUP BY pl.[Name], pl.Seats
ORDER BY Passengers DESC, pl.[Name], pl.Seats





