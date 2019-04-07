--5

SELECT 
	   CardNumber,
	   JobDuringJourney
  FROM TravelCards 
ORDER BY CardNumber

--6

SELECT
	   Id,
	   FirstName + ' ' + LastName AS FullName,
	   Ucn
  FROM Colonists
ORDER BY FirstName, LastName, Id

--7

SELECT 
	   Id,
	   CONVERT(VARCHAR, JourneyStart, 103) AS JourneyStart,
	   CONVERT(VARCHAR, JourneyEnd, 103) AS JourneyEnd
  FROM Journeys
WHERE Purpose = 'Military'
ORDER BY JourneyStart

SELECT * FROM Journeys

--8

SELECT 
	   c.Id AS id,
	   c.FirstName + ' ' + c.LastName AS full_name
  FROM Colonists AS c
  JOIN TravelCards AS t
    ON t.ColonistId = c.Id AND t.JobDuringJourney = 'Pilot'
ORDER BY c.Id

--9

SELECT 
	   COUNT(c.Id) AS [count]
  FROM Colonists AS c 
  JOIN TravelCards AS t
    ON t.ColonistId = c.Id 
  JOIN Journeys AS j
    ON t.JourneyId = j.Id 
   AND j.Purpose = 'Technical'

--10

SELECT TOP 1
	   ssh.[Name] AS SpaceshipName,
	   ssp.[Name] AS SpaceportName
  FROM Spaceships AS ssh
  JOIN Journeys AS j
    ON j.SpaceshipId = ssh.Id
  JOIN Spaceports AS ssp
    ON ssp.Id = j.DestinationSpaceportId
ORDER BY ssh.LightSpeedRate DESC

--11

SELECT 
	   ssh.[Name],
	   ssh.Manufacturer
  FROM Colonists AS c
  JOIN TravelCards AS t
    ON t.ColonistId = c.Id
  JOIN Journeys AS j
    ON j.Id = t.JourneyId
  JOIN Spaceships AS ssh
    ON ssh.id = j.SpaceshipId
 WHERE DATEDIFF(YEAR, c.BirthDate, '01/01/2019') < 30 
   AND t.JobDuringJourney = 'Pilot'
ORDER BY ssh.[Name]

--12

SELECT 
	   p.[Name],
	   ssp.[Name]
  FROM Journeys AS j
  JOIN Spaceports AS ssp
    ON ssp.Id = j.DestinationSpaceportId
  JOIN Planets AS p
    ON P.Id = ssp.PlanetId
WHERE j.Purpose = 'Educational'
ORDER BY ssp.[Name] DESC

--13

SELECT 
	   pl.[Name],
	   COUNT(pl.[Name]) AS JourneyCount
  FROM 
		(SELECT p.[Name] 
		   FROM Planets AS p
		   JOIN Spaceports AS ssp
		     ON ssp.PlanetId = p.Id
		   JOIN Journeys AS j
			 ON ssp.Id = j.DestinationSpaceportId
		) pl
GROUP BY pl.[Name]
ORDER BY JourneyCount DESC, pl.[Name]
 
--14

SELECT TOP 1
	   j.Id,
	   p.[Name],
	   ssp.[Name],
	   j.Purpose
  FROM Planets AS p
  JOIN Spaceports AS ssp
    ON ssp.PlanetId = p.Id
  JOIN Journeys AS j
    ON j.DestinationSpaceportId = ssp.Id
ORDER BY DATEDIFF(SECOND, j.JourneyStart, j.JourneyEnd)

--15

SELECT TOP 1
	   j.Id,
	   'Engineer'
  FROM Planets AS p
  JOIN Spaceports AS ssp
    ON ssp.PlanetId = p.Id
  JOIN Journeys AS j
    ON j.DestinationSpaceportId = ssp.Id
ORDER BY DATEDIFF(SECOND, j.JourneyStart, j.JourneyEnd) DESC

--16

SELECT 
	   k.JobDuringJourney, 
	   c.FirstName + ' ' + c.LastName AS FullName, 
	   k.JobRank
  FROM (
		SELECT tc.JobDuringJourney AS JobDuringJourney, 
			   tc.ColonistId,
DENSE_RANK() OVER (
			 PARTITION BY tc.JobDuringJourney 
			 ORDER BY co.Birthdate ASC) AS JobRank
		FROM TravelCards AS tc
		JOIN Colonists AS co 
		  ON co.Id = tc.ColonistId
    GROUP BY tc.JobDuringJourney, co.Birthdate, tc.ColonistId
				  ) AS k
  JOIN Colonists AS c 
    ON c.Id = k.ColonistId
 WHERE k.JobRank = 2
ORDER BY k.JobDuringJourney

--17

SELECT 
	   pl.PlanetName,
	   pl.[Count]
  FROM 
		(	
	SELECT 
		   p.[Name] AS PlanetName,
		   COUNT(sp.Id) AS [Count]
	  FROM Planets AS p
 LEFT JOIN Spaceports AS sp
	    ON sp.PlanetId = p.Id
  GROUP BY p.[Name]
		) pl
ORDER BY pl.[Count] DESC, 
		 pl.PlanetName





