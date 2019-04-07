--18

CREATE FUNCTION dbo.udf_GetColonistsCount(@PlanetName VARCHAR(50))
RETURNS INT
BEGIN
	DECLARE @CountOfPlanets INT
	
	SET @CountOfPlanets = 
	(SELECT 
		   COUNT(*)
	  FROM Colonists AS c
	  JOIN TravelCards AS tc
	    ON tc.ColonistId = c.Id
	  JOIN Journeys AS j
	    ON j.Id = tc.JourneyId
	  JOIN Spaceports AS sp
	    ON sp.Id = j.DestinationSpaceportId
	  JOIN Planets AS p
	    ON sp.PlanetId = p.Id
	 WHERE p.[Name] = @PlanetName)

	RETURN @CountOfPlanets
END

GO

SELECT dbo.udf_GetColonistsCount('Otroyphus')

--19

GO
CREATE PROC usp_ChangeJourneyPurpose(@JourneyId INT , @NewPurpose VARCHAR(50))
AS
BEGIN
	DECLARE @CurrentJourneyId INT = 
		(SELECT Id FROM Journeys WHERE Id = @JourneyId);

	IF(@CurrentJourneyId IS NULL)
	BEGIN
		;THROW 51000, 'The journey does not exist!', 1
	END

	DECLARE @CurrentPurpose VARCHAR(50) = 
		(SELECT Purpose FROM Journeys WHERE Id = @CurrentJourneyId)

	IF(@CurrentPurpose = @NewPurpose)
	BEGIN
		;THROW 51000, 'You cannot change the purpose!', 2
	END

	UPDATE Journeys
	   SET Purpose = @NewPurpose
	 WHERE Id = @JourneyId
END

EXEC usp_ChangeJourneyPurpose 1, 'Technical'
SELECT * FROM Journeys

EXEC usp_ChangeJourneyPurpose 2, 'Educational'

--20
GO

CREATE TABLE DeletedJourneys
(
	Id INT,
	JourneyStart DATETIME,
	JourneyEnd DATETIME,
	Purpose VARCHAR(11),
	DestinationSpaceportId INT,
	SpaceshipId INT
)

GO

CREATE TRIGGER t_DeleteJourney
	ON Journeys
	AFTER DELETE
	AS
	BEGIN
		INSERT INTO DeletedJourneys (Id,JourneyStart,JourneyEnd, Purpose, DestinationSpaceportId, SpaceshipId)
		SELECT Id,JourneyStart,JourneyEnd, Purpose, DestinationSpaceportId, SpaceshipId FROM deleted
	END