--01. One-To-One Relationship--

CREATE TABLE Persons (
PersonID INT NOT NULL,
FirstName NVARCHAR(50) NOT NULL,
Salary INT NOT NULL,
PassportID INT NOT NULL
)

CREATE TABLE Passports (
PassportID INT NOT NULL,
PassportNumber NVARCHAR(50) NOT NULL
)

INSERT INTO Persons
	VALUES 
		(1, 'Roberto', 43300.00, 102),
		(2, 'Tom', 56100.00, 103),
		(3, 'Yana', 60200.00, 101)

INSERT INTO Passports
	VALUES 
		(101, 'N34FG21B'),
		(102, 'K65LO4R7'),
		(103, 'ZE657QP2')

ALTER TABLE Persons
ADD CONSTRAINT PK_PersonsID PRIMARY KEY (PersonID)

ALTER TABLE Passports
ADD CONSTRAINT PK_PassportID PRIMARY KEY (PassportID)

ALTER TABLE Persons
ADD CONSTRAINT FK_Passports_Persons FOREIGN KEY (PassportID) 
REFERENCES Passports(PassportID)

--02. One-To-Many Relationship--
CREATE TABLE Models (
	ModelID INT NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	ManufacturerID INT NOT NULL
)

CREATE TABLE Manufacturers (
	ManufacturerID INT NOT NULL,
	[Name] NVARCHAR(50) NOT NULL,
	EstablishedOn DATETIME2 NOT NULL
)

INSERT INTO Models
	VALUES 
		(101, 'X1', 1),
		(102, 'i6', 1),
		(103, 'Model S', 2),
		(104, 'Model X', 2),
		(105, 'Model 3', 2),
		(106, 'Nova', 3)

INSERT INTO Manufacturers
	VALUES
		(1, 'BMW', '07/03/1916'),
		(2, 'Tesla', '01/01/2003'),
		(3, 'Lada', '01/05/1966')

ALTER TABLE Models
	ADD CONSTRAINT PK_ModelID PRIMARY KEY (ModelID)

ALTER TABLE Manufacturers
	ADD CONSTRAINT PK_ManufacturerID PRIMARY KEY (ManufacturerID)

ALTER TABLE Models
	ADD CONSTRAINT FK_ManufacturerID_ModelID FOREIGN KEY (ManufacturerID)
	REFERENCES Manufacturers(ManufacturerID)

--03. Many-To-Many Relationship--
CREATE TABLE Students (
	StudentID INT IDENTITY PRIMARY KEY,
	[Name] NVARCHAR(50),
)
 
CREATE TABLE Exams (
	ExamID INT PRIMARY KEY,
	[Name] NVARCHAR(50)
)

CREATE TABLE StudentsExams (
	StudentID INT NOT NULL,
	ExamID INT NOT NULL,

	CONSTRAINT PK_StudentsExams PRIMARY KEY (StudentID, ExamID),

	CONSTRAINT FK_StudentsExams_Students FOREIGN KEY (StudentID)
	REFERENCES Students(StudentID),

	CONSTRAINT FK_StudentsExams_Exams FOREIGN KEY (ExamID)
	REFERENCES Exams(ExamID)
)

INSERT INTO Students
	VALUES 
		('Mila'),
		('Toni'),
		('Ron')

INSERT INTO Exams
	VALUES 
		(101, 'SpringMVC'),
		(102, 'Neo4j'),
		(103, 'Oracle 11g')

INSERT INTO StudentsExams
	VALUES
		(1, 101),
		(1, 102),
		(2, 101),
		(3, 103),
		(2, 102),
		(2, 103)

		--ANOTHER WAY TO MAKE MANY-TO-MANY RELATIONSHIP--

ALTER TABLE	Students
	ADD CONSTRAINT PK_StudentID PRIMARY KEY (StudentID)

ALTER TABLE Exams
	ADD CONSTRAINT PK_ExamID PRIMARY KEY (ExamID)

ALTER TABLE StudentsExams
	ADD CONSTRAINT FK_StudentsExams_Students FOREIGN KEY (StudentID)
	REFERENCES Students(StudentID),

	CONSTRAINT FK_StudentsExams_Exams FOREIGN KEY (ExamID)
	REFERENCES Exams(ExamID),

	CONSTRAINT PK_StudentsExams PRIMARY KEY (StudentID, ExamID);

--04. Self-Referencing--
CREATE TABLE Teachers (
	TeacherID INT PRIMARY KEY,
	[Name] NVARCHAR,
	ManagerID INT,

	CONSTRAINT FK_Managers_Teachers FOREIGN KEY (ManagerID)
	REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers
	(TeacherID, [Name], ManagerID)
		VALUES
	(101, 'John', NULL),
	(102, 'Maya', 106),
	(103, 'Silvia', 106),
	(104, 'Ted', 105),
	(105, 'Mark', 101),
	(106, 'Greta', 101)

--05. Online Store Database--
CREATE TABLE Customers (
	CustomerID INT,
	[Name] VARCHAR(50),
	Birthday DATE,
	CityID INT,

	CONSTRAINT PK_CustomerID PRIMARY KEY (CustomerID),
	CONSTRAINT FK_Customers_Cities FOREIGN KEY (CityID) 
	REFERENCES Cities (CityID)
)

CREATE TABLE Cities (
	CityID INT,
	[Name] VARCHAR(50),

	CONSTRAINT PK_CityID PRIMARY KEY (CityID)
)

CREATE TABLE Orders (
	OrderID INT,
	CustomerId INT,

	CONSTRAINT PK_OrderID PRIMARY KEY (OrderID),
	CONSTRAINT FK_Customer_Order FOREIGN KEY (CustomerID)
	REFERENCES Customers(CustomerID)
)

CREATE TABLE Items (
	ItemID INT,
	[Name] VARCHAR(50),
	ItemTypeID INT,

	CONSTRAINT PK_ItemsID PRIMARY KEY (ItemID),
	CONSTRAINT FK_ItemTypeID FOREIGN KEY (ItemTypeID)
	REFERENCES ItemTypes (ItemTypeID)
)

CREATE TABLE OrderItems (
	OrderID INT,
	ItemID INT,

	CONSTRAINT FK_OrderID FOREIGN KEY (OrderID)
	REFERENCES Orders (OrderID),
	CONSTRAINT FK_ItemID FOREIGN KEY (OrderID)
	REFERENCES Items (ItemID)
)

CREATE TABLE ItemTypes (
	ItemTypeID INT,
	[Name] VARCHAR(50),

	CONSTRAINT PK_ItemTypeID PRIMARY KEY (ItemTypeID)
)

----------------

CREATE TABLE Orders (
	OrderID INT PRIMARY KEY,
	CustomerID INT
)

CREATE TABLE Customers (
	CustomerID INT PRIMARY KEY,
	[Name] VARCHAR(50),
	Birthday DATE,
	CityID INT
)

CREATE TABLE Cities (
	CityID INT PRIMARY KEY,
	[Name] VARCHAR(50)
)

CREATE TABLE OrderItems (
	OrderID INT,
	ItemID INT,

	CONSTRAINT PK_OrderItems PRIMARY KEY (OrderID, ItemID)
)

CREATE TABLE Items (
	ItemID INT PRIMARY KEY,
	[Name] VARCHAR(50),
	ItemTypeID INT
)

CREATE TABLE ItemTypes (
	ItemTypeID INT PRIMARY KEY,
	[Name] VARCHAR(50)	
)

ALTER TABLE Orders 
	ADD
		CONSTRAINT FK_Customer_Orders FOREIGN KEY (CustomerID)
		REFERENCES Customers(CustomerID);

ALTER TABLE Customers
	ADD
		CONSTRAINT FK_Customer_City FOREIGN KEY (CityID)
		REFERENCES Cities(CityID);

ALTER TABLE OrderItems
	ADD
		CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderID)
		REFERENCES Orders(OrderID),

		CONSTRAINT FK_OrderItems_Items FOREIGN KEY (ItemID)
		REFERENCES Items(ItemID);

ALTER TABLE Items
	ADD
		CONSTRAINT FK_ItemTypeID FOREIGN KEY (ItemTypeID)
		REFERENCES ItemTypes(ItemTypeID)

--06. University Database--
CREATE TABLE Majors (
	MajorID INT PRIMARY KEY,
	[Name] VARCHAR(50)
)

CREATE TABLE Students (
	StudentId INT PRIMARY KEY,
	StudentNumber INT,
	StudentName VARCHAR(50),
	MajorID INT
)

CREATE TABLE Payments (
	PaymentID INT PRIMARY KEY,
	PaymentDate DATE,
	PaymentAmount INT,
	StudentID int
)

CREATE TABLE Agenda (
	StudentID INT,
	SubjectID INT,
	
	CONSTRAINT PK_Agenda PRIMARY KEY (StudentID, SubjectID)
)

CREATE TABLE Subjects (
	SubjectID INT PRIMARY KEY,
	SubjectName VARCHAR(50)
)

ALTER TABLE Students
	ADD
		CONSTRAINT FK_Student_Major FOREIGN KEY (MajorID)
		REFERENCES Majors(MajorID);

ALTER TABLE Payments 
	ADD
		CONSTRAINT FK_Student_Payments FOREIGN KEY (StudentID)
		REFERENCES Students(StudentID)

ALTER TABLE Agenda
	ADD
		CONSTRAINT FK_Agenda_StudentID FOREIGN KEY (StudentID)
		REFERENCES Students(StudentID),

		CONSTRAINT FK_Agenda_Subjectid FOREIGN KEY (SubjectID)
		REFERENCES Subjects(SubjectID)

--09. Peaks in Rila--

SELECT 
	r.MountainRange, 
	p.PeakName,
    p.Elevation
FROM Mountains AS r
	INNER JOIN Peaks AS p
	ON r.Id = p.MountainId
WHERE r.MountainRange = 'Rila'
ORDER BY p.Elevation DESC