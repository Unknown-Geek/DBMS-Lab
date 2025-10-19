-- FACULTY TABLE
CREATE TABLE FACULTY(
	StaffID INT PRIMARY KEY,
	Title VARCHAR(30) NOT NULL,
	Status VARCHAR(30) NOT NULL,
	Tenured INT NOT NULL,
	FOREIGN KEY (StaffID) REFERENCES STAFF(StaffID)
);

-- STAFF
CREATE TABLE STAFF (
	StaffID INT PRIMARY KEY,
	StfFirstName VARCHAR(30) NOT NULL,
	StfLastName VARCHAR(30) NOT NULL,
	StfStreetAddress VARCHAR(30) NOT NULL,
	StfCity VARCHAR(30) NOT NULL,
	StfState VARCHAR(30) NOT NULL,
	StfZipCode INT NOT NULL,
	StfAreaCode INT NOT NULL,
	StfPhoneNumber INT NOT NULL,
	DateHired DATE NOT NULL,
	Salary INT NOT NULL,
	Position VARCHAR(30) NOT NULL
);

-- FACULTY_CATEGORIES
CREATE TABLE FACULTY_CATEGORIES (
	StaffID INT,
	CategoryID INT,
	PRIMARY KEY(StaffID,CategoryID),
	FOREIGN KEY (StaffID) REFERENCES STAFF(StaffID),
	FOREIGN KEY (CategoryID) REFERENCES CATEGORIES(CategoryID)
);

-- CATEGORIES
CREATE TABLE CATEGORIES(
	CategoryID INT PRIMARY KEY,
	CategoryDescription VARCHAR(30) NOT NULL,
	DepartmentID INT NOT NULL
);

-- SUBJECTS
CREATE TABLE SUBJECTS (
	SubjectID INT PRIMARY KEY,
	CategoryID INT,
	SubjectCode INT NOT NULL,
	SubjectName VARCHAR(30) NOT NULL,
	SubjectDescription VARCHAR(30) NOT NULL,
	FOREIGN KEY (CategoryID) REFERENCES CATEGORIES(CategoryID)
);

-- FACULTY_CLASSES
CREATE TABLE FACULTY_CLASSES (
	StaffID INT,
	ClassID INT,
	PRIMARY KEY(StaffID,ClassID),
	FOREIGN KEY (StaffID) REFERENCES STAFF(StaffID),
	FOREIGN KEY (ClassID) REFERENCES CLASSES(ClassID)
);

-- BUILDINGS
CREATE TABLE BUILDINGS(
	BuildingCode INT PRIMARY KEY,
	BuildingName VARCHAR(30) NOT NULL,
	NumberofFloors INT NOT NULL
);

-- CLASSROOMS
CREATE TABLE CLASSROOMS(
	ClassRoomID INT PRIMARY KEY,
	BuildingCode INT,
	PhoneAvailable INT NOT NULL,
	FOREIGN KEY (BuildingCode) REFERENCES BUILDINGS(BuildingCode)
);

-- CLASSES
CREATE TABLE CLASSES(
	CLassID INT PRIMARY KEY,
	SubjectID INT,
	ClassRoomID INT,
	StartTime TIME NOT NULL,
	Duration INT NOT NULL,
	FOREIGN KEY (SubjectID) REFERENCES SUBJECTS(SubjectID),
	FOREIGN KEY (ClassRoomID) REFERENCES CLASSROOMS(ClassRoomID)
);

-- FACULTY_SUBJECTS
CREATE TABLE FACULTY_SUBJECTS(
	StaffID INT ,
	SubjectID INT,
	ProficiencyRating INT NOT NULL,
	PRIMARY KEY(StaffID,SubjectID),
	FOREIGN KEY (StaffID) REFERENCES STAFF(StaffID),
	FOREIGN KEY (SubjectID) REFERENCES SUBJECTS(SubjectID)
);

-- FACULTY_CLASSES
CREATE TABLE FACULTY_CLASSES(
	StaffID INT ,
	ClassID INT,
	PRIMARY KEY(StaffID,ClassID),
	FOREIGN KEY (StaffID) REFERENCES STAFF(StaffID),
	FOREIGN KEY (ClassID) REFERENCES CLASSES(ClassID)
);

-- STUDENTS
CREATE TABLE STUDENTS (
	StudentID INT PRIMARY KEY,
	StudFirstName VARCHAR(30) NOT NULL,
	StudLastName VARCHAR(30) NOT NULL,
	StudStreetAddress VARCHAR(30) NOT NULL,
	StudCity VARCHAR(30) NOT NULL,
	StudState VARCHAR(30) NOT NULL,
	StudZipCode INT NOT NULL,
	StudAreaCode INT NOT NULL,
	StudPhoneNumber INT NOT NULL
);

-- STUDENT_CLASS_STATUS
CREATE TABLE STUDENT_CLASS_STATUS (
	ClassStatus INT PRIMARY KEY,
	ClassDescription VARCHAR(30) NOT NULL
);

-- STUDENT_SCHEDULES
CREATE TABLE STUDENT_SCHEDULES (
	ClassID INT,
	StudentID INT,
	ClassStatus INT,
	Grade VARCHAR(30) NOT NULL,
	PRIMARY KEY(ClassID,StudentID),
	FOREIGN KEY (ClassStatus) REFERENCES STUDENT_CLASS_STATUS(ClassStatus)
);

-- Alter table command to rename column
ALTER TABLE STAFF RENAME COLUMN DateHired TO JoiningDate;

-- Alter table command to remove column
ALTER TABLE SUBJECTS DROP COLUMN SubjectDescription;

-- Alter command to add salary>0 constraint in staff table
ALTER TABLE STAFF ADD CONSTRAINT Salary CHECK(Salary>0);

-- Inserting simple values into STAFF table
INSERT INTO STAFF (StaffID, StfFirstName, StfLastName, StfStreetAddress, StfCity, StfState, StfZipCode, StfAreaCode, StfPhoneNumber, DateHired, Salary, Position)
VALUES
(1, 'John', 'Doe', '1 St', 'City1', 'ST', 10001, 123, 1111111, '2020-01-01', 30000, 'Professor'),
(2, 'Jane', 'Smith', '2 St', 'City2', 'ST', 10002, 124, 1112222, '2019-02-01', 32000, 'Lecturer'),
(3, 'Mark', 'Taylor', '3 St', 'City3', 'ST', 10003, 125, 1113333, '2021-03-01', 28000, 'Assistant'),
(4, 'Emily', 'Davis', '4 St', 'City4', 'ST', 10004, 126, 1114444, '2018-04-01', 35000, 'Professor'),
(5, 'Chris', 'Brown', '5 St', 'City5', 'ST', 10005, 127, 1115555, '2022-05-01', 29000, 'Lecturer');

-- Inserting simple values into CATEGORIES table
INSERT INTO CATEGORIES (CategoryID, CategoryDescription, DepartmentID)
VALUES
(1, 'Math', 1),
(2, 'Science', 2),
(3, 'Arts', 3),
(4, 'History', 4),
(5, 'Literature', 5);

-- Inserting simple values into SUBJECTS table
INSERT INTO SUBJECTS (SubjectID, CategoryID, SubjectCode, SubjectName, SubjectDescription)
VALUES
(1, 1, 101, 'Math 101', 'Basic Math'),
(2, 2, 102, 'Sci 101', 'Basic Science'),
(3, 3, 103, 'Art 101', 'Introduction to Art'),
(4, 4, 104, 'Hist 101', 'World History'),
(5, 5, 105, 'Lit 101', 'Introduction to Literature');

-- Inserting simple values into BUILDINGS table
INSERT INTO BUILDINGS (BuildingCode, BuildingName, NumberofFloors)
VALUES
(1, 'Building A', 3),
(2, 'Building B', 4),
(3, 'Building C', 2),
(4, 'Building D', 3),
(5, 'Building E', 1);

-- Inserting simple values into CLASSROOMS table
INSERT INTO CLASSROOMS (ClassRoomID, BuildingCode, PhoneAvailable)
VALUES
(1, 1, 1),
(2, 2, 0),
(3, 3, 1),
(4, 4, 0),
(5, 5, 1);

-- Inserting simple values into CLASSES table
INSERT INTO CLASSES (ClassID, SubjectID, ClassRoomID, StartTime, Duration)
VALUES
(1, 1, 1, '09:00:00', 60),
(2, 2, 2, '10:00:00', 60),
(3, 3, 3, '11:00:00', 60),
(4, 4, 4, '12:00:00', 60),
(5, 5, 5, '13:00:00', 60);

-- Inserting simple values into FACULTY_CLASSES table
INSERT INTO FACULTY_CLASSES (StaffID, ClassID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- Inserting simple values into FACULTY_SUBJECTS table
INSERT INTO FACULTY_SUBJECTS (StaffID, SubjectID, ProficiencyRating)
VALUES
(1, 1, 5),
(2, 2, 4),
(3, 3, 3),
(4, 4, 5),
(5, 5, 4);

-- Inserting simple values into STUDENTS table
INSERT INTO STUDENTS (StudentID, StudFirstName, StudLastName, StudStreetAddress, StudCity, StudState, StudZipCode, StudAreaCode, StudPhoneNumber)
VALUES
(1, 'Anna', 'White', '6 St', 'City1', 'ST', 10006, 128, 1116666),
(2, 'Brian', 'Black', '7 St', 'City2', 'ST', 10007, 129, 1117777),
(3, 'Catherine', 'Green', '8 St', 'City3', 'ST', 10008, 130, 1118888),
(4, 'Daniel', 'Blue', '9 St', 'City4', 'ST', 10009, 131, 1119999),
(5, 'Eva', 'Red', '10 St', 'City5', 'ST', 10010, 132, 1120000);

-- Inserting simple values into STUDENT_CLASS_STATUS table
INSERT INTO STUDENT_CLASS_STATUS (ClassStatus, ClassDescription)
VALUES
(1, 'Enrolled'),
(2, 'Completed'),
(3, 'Dropped'),
(4, 'Failed'),
(5, 'Withdrawn');

-- Inserting simple values into STUDENT_SCHEDULES table
INSERT INTO STUDENT_SCHEDULES (ClassID, StudentID, ClassStatus, Grade)
VALUES
(1, 1, 1, 'A'),
(2, 2, 2, 'B'),
(3, 3, 3, 'C'),
(4, 4, 4, 'D'),
(5, 5, 5, 'F');

