--18 Vacation
CREATE FUNCTION udf_CalculateTickets(@origin VARCHAR(MAX), @destination VARCHAR(MAX), @peopleCount INT) 
RETURNS NVARCHAR(MAX)
AS
BEGIN
		IF (@peopleCount = 0)
	BEGIN
		RETURN 'Invalid people count!'
	END

	IF (@peopleCount < 0)
	BEGIN
		RETURN 'Invalid people count!'
	END

	DECLARE @originCheck NVARCHAR(MAX)= (SELECT Origin FROM Flights WHERE Origin = @origin)
	DECLARE @destinationCheck NVARCHAR(MAX)= (SELECT Destination FROM Flights WHERE Destination = @destination)

	IF (@originCheck IS NULL)
	BEGIN
		RETURN 'Invalid flight!'
	END

	IF (@destinationCheck IS NULL)
	BEGIN
		RETURN 'Invalid flight!'
	END

	DECLARE @Result DECIMAL(15, 2) = ((
	SELECT t.Price FROM Flights AS f
	JOIN Tickets AS t
	ON t.FlightId = f.Id
	WHERE f.Origin = @origin AND f.Destination = @destination) * @peopleCount)

	RETURN 'Total price ' + CAST(@Result AS NVARCHAR(max))
END

GO

--19 Wrong Data
CREATE PROCEDURE usp_CancelFlights
AS
BEGIN
	
	UPDATE
		Flights
	SET
		DepartureTime = NULL,
		ArrivalTime = NULL
	WHERE ArrivalTime > DepartureTime
END

GO



	Go

--20 Deleted Planes
CREATE TRIGGER t_DeletedPlanes
	ON Planes
	AFTER DELETE
AS
	BEGIN
		INSERT INTO DeletedPlanes(Id, [Name], Seats, [Range])
		SELECT Id, Name, Seats, Range FROM deleted
END