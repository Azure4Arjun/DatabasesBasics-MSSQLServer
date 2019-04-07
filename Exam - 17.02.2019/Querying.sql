--5 

SELECT
		FirstName,
		LastName,
		Age
  FROM Students
 WHERE Age >= 12
ORDER BY FirstName, LastName

--6

SELECT

	   FirstName + ' ' + CASE WHEN MiddleName IS NULL THEN + ' ' + LastName ELSE + MiddleName + ' '  + LastName END AS FullName,
	   [Address]
  FROM Students
 WHERE [Address] LIKE ('%road%')
ORDER BY FirstName, LastName, [Address]

--7

SELECT 
	   FirstName,
	   [Address],
	   Phone
  FROM Students
 WHERE Phone LIKE('42%') AND MiddleName IS NOT NULL
ORDER BY FirstName

--8

SELECT
	   s.FirstName,
	   s.LastName,
	   COUNT(st.TeacherId) AS countOfT
  FROM Students AS s
  JOIN StudentsTeachers AS st
    ON st.StudentId = s.Id
GROUP BY s.FirstName, s.LastName

--9
 
SELECT
	   t.FirstName + ' ' + t.LastName,
	   sub.[Name] + '-' + CAST(sub.Lessons AS VARCHAR) AS Subjects,
	   COUNT(st.StudentId) AS countOfT
  FROM Students AS s
  JOIN StudentsTeachers AS st
    ON st.StudentId = s.Id
  JOIN Teachers AS t
    ON t.Id = st.TeacherId
  JOIN Subjects AS sub
    ON sub.Id = t.SubjectId
GROUP BY t.FirstName, t.LastName, sub.[Name], sub.Lessons
ORDER BY countOfT DESC

--10

SELECT
	   s.FirstName + ' ' + s.LastName AS FullName
  FROM Students AS s
 LEFT JOIN StudentsExams AS se
    ON se.StudentId = s.Id
 WHERE se.ExamId IS NULL
ORDER BY FullName

--11

SELECT TOP 10
	   t.FirstName,
	   t.LastName,
	   COUNT(st.StudentId) AS countOfS
  FROM Students AS s
  JOIN StudentsTeachers AS st
    ON st.StudentId = s.Id
  JOIN Teachers AS t
    ON t.Id = st.TeacherId
GROUP BY t.FirstName, t.LastName
ORDER BY countOfS DESC, t.FirstName, t.LastName

--12

SELECT TOP 10
	   s.FirstName, 
	   s.LastName,
	   CAST(AVG(st.Grade) AS DECIMAL(16,2)) AS avgGrade
  FROM Students AS s
  JOIN StudentsExams AS st
    ON st.StudentId = s.Id
GROUP BY s.FirstName, s.LastName
ORDER BY avgGrade DESC, s.FirstName, s.LastName

--13

SELECT
	   a.FirstName,
	   a.LastName,
	   a.Grade
  FROM 
	  (
		SELECT
		       FirstName,
			   LastName,
			   ss.Grade,
			   ROW_NUMBER() OVER 
			   (PARTITION BY s.Id ORDER BY ss.Grade DESC)
			   AS [Ranks]
		  FROM Students AS s
		  JOIN StudentsSubjects AS ss
		    ON ss.StudentId = s.Id
	  ) AS a
 WHERE a.[Ranks] = 2
ORDER BY FirstName, LastName

--14

SELECT 
	   FirstName + ' ' 
	   + CASE WHEN MiddleName IS NULL THEN + LastName ELSE + MiddleName + ' ' 
	   + LastName END AS [FullName]
  FROM Students AS s
LEFT JOIN StudentsSubjects AS ss
    ON ss.StudentId = s.Id
	  WHERE ss.SubjectId IS NULL
ORDER BY [FullName]


--15

SELECT 
	   t.TeacherName,
	   t.SubjectName,
	   t.StudentName,
	   t.AvgGrade
  FROM (SELECT 
		t.FirstName + ' ' + t.LastName AS TeacherName,
		sub.Name AS SubjectName,
		s.FirstName + ' ' + s.LastName AS StudentName, 
		CAST(AVG(ss.Grade) AS DECIMAL(15,2)) AS AvgGrade,
		DENSE_RANK() OVER(
						  PARTITION BY t.FirstName, t.LastName
						  ORDER BY AVG(ss.Grade) DESC) AS Rank
   FROM Students AS s 
   JOIN StudentsSubjects AS ss
     ON s.Id = ss.StudentId
   JOIN Subjects AS sub
     ON ss.SubjectId = sub.Id 
   JOIN StudentsTeachers AS st
     ON s.Id = st.StudentId
   JOIN Teachers AS t
     ON t.SubjectId = sub.Id 
	AND t.Id = st.TeacherId
GROUP BY t.FirstName, 
		 t.LastName, 
		 sub.[Name],
		 s.FirstName, 
		 s.LastName ) AS t
 WHERE t.Rank = 1
ORDER BY t.SubjectName,
	     t.TeacherName, 
		 t.AvgGrade DESC

--16

SELECT s.[Name], 
	   AVG(st.Grade) AS [AverageGrade]
  FROM Subjects AS s
  JOIN StudentsSubjects AS st 
    ON st.SubjectId = s.Id
GROUP BY s.[Name], s.Id 
ORDER BY s.Id

--17

SELECT
	    t.[Quarter],
	    t.Name,
	    COUNT(t.StudentId) AS StudentsCount
  FROM (SELECT
	CASE 
		WHEN MONTH(e.Date) BETWEEN 1 AND 3 THEN 'Q1'
		WHEN MONTH(e.Date) BETWEEN 4 AND 6 THEN 'Q2'
		WHEN MONTH(e.Date) BETWEEN 7 AND 9 THEN 'Q3'
		WHEN MONTH(e.Date) BETWEEN 10 AND 12 THEN 'Q4'
		WHEN e.Date IS NULL THEN 'TBA'
	 END AS [Quarter],
	 sub.Name,
	 se.StudentId
  FROM Subjects AS sub
  LEFT JOIN Exams AS e 
    ON e.SubjectId = sub.Id
  LEFT JOIN StudentsExams AS se 
    ON se.ExamId = e.Id
 WHERE se.Grade >= 4.00) AS t
GROUP BY t.[Quarter], t.[Name]
ORDER BY t.[Quarter]

