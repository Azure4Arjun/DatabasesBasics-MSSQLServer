--18

CREATE FUNCTION udf_ExamGradesToUpdate(@studentId INT , @grade DECIMAL(15,2))
RETURNS VARCHAR(MAX)

BEGIN
	DECLARE @FinalMessage VARCHAR(MAX) 

	DECLARE @TargetStudentId INT = (SELECT Id FROM Students WHERE Id = @studentId)
	
	IF(@TargetStudentId IS NULL)
	BEGIN
		SET @FinalMessage = 'The student with provided id does not exist in the school!'
	END
	ELSE IF (@TargetStudentId IS NOT NULL)
	BEGIN

		IF(@grade > 6.00)
		BEGIN
			SET @FinalMessage = 'Grade cannot be above 6.00!'
		END
		ELSE
		BEGIN
			DECLARE @StudentGradesCount INT = 
			(
				SELECT 
				       c.countG
				  FROM (SELECT 
							   COUNT(se.Grade) AS countG
						  FROM StudentsExams AS se
						 WHERE se.StudentId = @TargetStudentId 
						   AND se.Grade BETWEEN @grade AND @grade + 0.50
				  ) AS c
			)
			DECLARE @StudentFirstName VARCHAR(MAX) = (SELECT FirstName FROM Students WHERE Id = @TargetStudentId)

			SET @FinalMessage = 'You have to update ' + CAST(@StudentGradesCount AS VARCHAR(50)) + ' grades for the student ' + @StudentFirstName
		END
	END

	RETURN @FinalMessage
END

GO

SELECT dbo.udf_ExamGradesToUpdate(12, 5.50)

--19

GO

CREATE PROCEDURE usp_ExcludeFromSchool(@StudentId INT)
AS
BEGIN
	DECLARE @TargetStudentId INT = (SELECT Id FROM Students WHERE Id = @StudentId)

	IF(@TargetStudentId IS NULL)
	BEGIN
		;THROW 51000, 'This school has no student with the provided id!', 1
	END

	DELETE FROM StudentsTeachers
	WHERE StudentId = @TargetStudentId

	DELETE FROM StudentsSubjects
	WHERE StudentId = @TargetStudentId

	DELETE FROM StudentsExams
	WHERE StudentId = @TargetStudentId

	DELETE FROM Students
	WHERE Id = @TargetStudentId
END
GO

EXEC usp_ExcludeFromSchool 1
SELECT COUNT(*) FROM Students

--20

CREATE TABLE ExcludedStudents
(
	StudentId INT,
	StudentName NVARCHAR(50)
)

GO

CREATE TRIGGER t_ExcludeStudents
	ON Students
	AFTER DELETE
AS
	BEGIN
		INSERT INTO ExcludedStudents(StudentId, StudentName)
		SELECT Id, FirstName + ' ' + LastName FROM deleted
END

DELETE FROM StudentsExams
WHERE StudentId = 1

SELECT * FROM ExcludedStudents
