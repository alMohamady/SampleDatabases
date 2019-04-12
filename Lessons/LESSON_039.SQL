-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 39 - Modifying Data
-- 
-- Ahmed Mohamady 
--------------------------------------------------------
-----------------------------------------------------------
-- Updating Data

-- Updating a single column of a single row
USE NEW_DB
UPDATE dbo.Guide 
  SET Qualifications = 'Spelunking, Cave Diving, Rock Climbing, First Aid, Navigation'
  Where GuideID = 6; 

SELECT GuideID, LastName, Qualifications 
  FROM dbo.Guide
  WHERE GuideID = 6;

-- Global Search and Replace

USE Family;

UPDATE Person
  SET LastName = REPLACE(Lastname, 'll', 'qua');

SELECT lastname 
  FROM Person;


-- A complex update with expression

USE NEW_DB;

CREATE TABLE dbo.Dept (
  DeptID INT IDENTITY NOT NULL PRIMARY KEY NONCLUSTERED,
  DeptName VARCHAR(50) NOT NULL,
  RaiseFactor NUMERIC(4,2)
   ) 
  ON [Primary];
go

Create  TABLE dbo.Employee (
  EmployeeID INT IDENTITY NOT NULL PRIMARY KEY NONCLUSTERED,
  DeptID INT FOREIGN KEY REFERENCES Dept, 
  LastName VARCHAR(50) NOT NULL,
  FirstName VARCHAR(50) NOT NULL,
  Salary INT,
  PerformanceRating NUMERIC(4,2),
  DateHire DATETIME,
  DatePosition DATETIME
   ) 
  ON [Primary];
go
 -- build the sample data
INSERT dbo.Dept VALUES ('Engineering', 1.2);
INSERT dbo.Dept VALUES ('Sales',.8);
INSERT dbo.Dept VALUES ('IT',2.5);
INSERT dbo.Dept VALUES ('Manufacturing',1.0);
go
INSERT dbo.Employee VALUES( 1, 'Smith', 'Sam', 54000, 2.0, '1/1/97', '4/1/2001' );
INSERT dbo.Employee VALUES( 1, 'Nelson', 'Slim', 78000, 1.5, '9/1/88', '1/1/2000' );
INSERT dbo.Employee VALUES( 2, 'Ball', 'Sally', 45000, 3.5, '2/1/99', '1/1/2001' );
INSERT dbo.Employee VALUES( 2, 'Kelly', 'Jeff', 85000, 2.4, '10/1/83','9/1/1998' );
INSERT dbo.Employee VALUES( 3, 'Guelzow', 'Dave', 120000, 4.0, '7/1/95', '6/1/2001' );
INSERT dbo.Employee VALUES( 3, 'Cliff', 'Melissa', 95000, 1.8, '2/1/99', '9/1/1997' );
INSERT dbo.Employee VALUES( 4, 'Reagan', 'Frankie', 75000, 2.9, '4/1/00', '4/1/2000' );
INSERT dbo.Employee VALUES( 4, 'Adams', 'Hank', 34000, 3.2, '9/1/98', '9/1/1998' );
go 

-- assume raise date is 5/1/2002
SELECT * from dbo.Dept;
SELECT * from dbo.Employee;

-- test required data
SELECT   LastName, Salary,
  DateDiff(yy, DateHire, '5/1/2002') as YearsCompany,
  DateDiff(mm, DatePosition, '5/1/2002') as MonthPosition,
  CASE   
    WHEN Employee.PerformanceRating >= 2 THEN Employee.PerformanceRating
    ELSE 0
  END as Performance, 
  Dept.RaiseFactor
  FROM dbo.Employee
  JOIN dbo.Dept 
    ON Employee.DeptID = Dept.DeptID;

-- Test the raise amount 
SELECT   LastName, 
  (2 + (((DateDiff(yy, DateHire, '5/1/2002') * .1)
  + (DateDiff(mm, DatePosition, '5/1/2002') * .02)
  + (CASE   
      WHEN Employee.PerformanceRating >= 2 THEN Employee.PerformanceRating
      ELSE 0
     END * .5 ))
   * Dept.RaiseFactor))/100 as EmpRaise
  FROM dbo.Employee
  JOIN dbo.Dept 
    ON Employee.DeptID = Dept.DeptID;

-- Perform the Update 
Update Employee Set Salary = Salary * (1 + 
  (2 + (((DateDiff(yy, DateHire, '5/1/2002') * .1)
  + (DateDiff(mm, DatePosition, '5/1/2002') * .02)
  + (CASE   
      WHEN Employee.PerformanceRating >= 2 THEN Employee.PerformanceRating
      ELSE 0
     END * .5 ))
   * Dept.RaiseFactor))/100 )
  FROM dbo.Employee
  JOIN dbo.Dept 
    ON Employee.DeptID = Dept.DeptID;


SELECT FirstName, LastName, Salary
  FROM dbo.Employee;
Go

Drop Table dbo.Employee;
Go
Drop table dbo.Dept ;