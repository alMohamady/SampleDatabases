
-----------------------------------------------------------
-- Family sample database - CREATE

-- this script will drop an existing Family database 
-- and create a fresh new installation

-----------------------------------------------------------
-----------------------------------------------------------
-- Drop and Create Database


USE master
GO
IF EXISTS (SELECT * FROM SysDatabases WHERE NAME='Family')
		DROP DATABASE Family
go

-- This creates the database data file and log file on the default directories
CREATE DATABASE Family
go

use Family
go


-----------------------------------------------------------
-----------------------------------------------------------
-- Create Tables, in order from primary to secondary

CREATE TABLE dbo.Person (
  PersonID  INT NOT NULL PRIMARY KEY NONCLUSTERED,
  LastName  VARCHAR(15) NOT NULL,
  FirstName  VARCHAR(15) NOT NULL,
  SrJr  VARCHAR(3) NULL,
  MaidenName VARCHAR(15) NULL,
  Gender CHAR(1) NOT NULL, 
  FatherID INT NULL,
  MotherID INT NULL,
  DateOfBirth  DATETIME  NULL,
  DateOfDeath  DATETIME  NULL
  );

go
CREATE CLUSTERED INDEX IxPersonName 
  ON dbo.Person (LastName, FirstName);
ALTER TABLE dbo.Person ADD CONSTRAINT
	FK_Person_Father FOREIGN KEY	(FatherID) REFERENCES dbo.Person (PersonID);
ALTER TABLE dbo.Person ADD CONSTRAINT
	FK_Person_Mother FOREIGN KEY	(MotherID) REFERENCES dbo.Person (PersonID);
go 

CREATE TABLE dbo.Marriage (
  MarriageID  INT NOT NULL PRIMARY KEY NONCLUSTERED,
  HusbandID  INT NOT NULL FOREIGN KEY REFERENCES dbo.Person,
  WifeID  INT NOT NULL FOREIGN KEY REFERENCES dbo.Person,
  DateOfWedding DATETIME NULL,
  DateOfDivorce DATETIME NULL
  )
go 

----------------------------------------------------------------------------
-- Custom Constraints

CREATE TRIGGER Person_Parents
ON Person
AFTER INSERT, UPDATE
AS 
-- check that if the parent is listed that the gender is correct

IF UPDATE(FatherID)
  BEGIN
    -- Incorrect Father Gender
    IF EXISTS(SELECT * FROM Person JOIN Inserted ON Inserted.FatherID = Person.PersonID WHERE Person.Gender = 'F')  
      BEGIN  
        ROLLBACK
        RAISERROR('Incorrect Gender for Father',14,1)
        RETURN
     END 
  END

  -- Invalid Father Age


  -- Father Deceased


IF UPDATE(MotherID)
  BEGIN
    -- Incorrect Mother Gender
    IF EXISTS(SELECT * FROM Person JOIN Inserted ON Inserted.MotherID = Person.PersonID WHERE Person.Gender = 'M')  
      BEGIN  
        ROLLBACK
        RAISERROR('Incorrect Gender for Mother',14,1)
        RETURN
     END 
  END

  -- Invalid Mother age



  -- Mother Deceased


RETURN


go
----------------------------------------------------------------------------
-- Sample Data

INSERT dbo.Person (PersonID, LastName, FirstName, MaidenName, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(1, 'Halloway', 'Kelly', 'Russell', 'F', NULL, NULL, '2/7/1904','5/13/1987')
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(2, 'Halloway', 'James', '1', 'M', NULL, NULL, '4/12/1899','5/1/2001')
INSERT dbo.Person (PersonID, LastName, FirstName, MaidenName, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(3,'Miller', 'Karen', 'Conley', 'F', NULL, NULL, '9/11/1909','8/1/1974')
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(4, 'Miller', 'Bryan', NULL, 'M', NULL, NULL, '4/12/1902','4/16/1948')
go
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(5, 'Halloway', 'James', '2', 'M', 2, 1, '5/19/1922','2/2/1992')
INSERT dbo.Person (PersonID, LastName, FirstName, MaidenName, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(6, 'Halloway', 'Audry', 'Ross', 'F', 4, 3, '8/5/1928','3/12/2002')
go
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(7, 'Halloway', 'Corwin', NULL, 'M', 5, 6, '3/13/1961',NULL)  
INSERT dbo.Person (PersonID, LastName, FirstName, MaidenName, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(8, 'Campbell', 'Melanie', 'Halloway', 'F', 5, 6, '8/19/1951','6/28/2009')
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(9, 'Halloway', 'Dara', NULL, 'F', 5, 6, '12/12/1958','4/14/2010')
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(10, 'Halloway', 'James', 3, 'M', 5, 6, '8/30/1953','11/30/2007')
go
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(11, 'Kidd', 'Kimberly', NULL, 'F', NULL, NULL, '7/24/1963',NULL)
INSERT dbo.Person (PersonID, LastName, FirstName, MaidenName, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(12, 'Halloway', 'Alysia', 'Simmons', 'F', NULL, NULL, '3/5/1953',NULL)
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(13, 'Ramsey', 'Walter ', NULL, 'M', NULL, NULL, '9/30/1945',NULL)
go
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(14, 'Halloway', 'Logan', NULL, 'M', 7, 11,'2/6/1994',NULL)
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(15, 'Ramsey', 'Shannon', NULL, 'F', 13, 8,'4/1/1970',NULL)
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(16, 'Ramsey', 'Jennifer', NULL, 'F', 13, 8,'6/1/1972','6/1/1972')
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(17, 'Halloway', 'Allie', NULL, 'F', 10, 12,'8/14/1979',NULL)
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(18, 'Halloway', 'Abbie', NULL, 'F', 10, 12,'8/14/1979',NULL)
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender,  FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(19, 'Halloway', 'James', 4, 'M',10, 12,'5/24/1975',NULL)
INSERT dbo.Person (PersonID, LastName, FirstName, MaidenName, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(20, 'Halloway', 'Grace', 'Stranes', 'F', NULL, NULL,'11/1/1977',NULL)
go
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(21, 'Halloway', 'James', 5, 'M', 19, 20,'9/4/2007',NULL)
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(22, 'Halloway', 'Chris', NULL, 'M', 19, 20, '7/4/2003',NULL)
go
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(23, 'Halloway', 'Joshua', NULL, 'M', NULL, 9,'6/25/1975',NULL)
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(24, 'Halloway', 'Laura', NULL, 'F', NULL, 9, '5/29/1977',NULL)
INSERT dbo.Person (PersonID, LastName, FirstName, MaidenName, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(25, 'Halloway', 'Katherine', 'Wood', 'F', NULL, NULL,'3/23/1996',NULL)
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(26, 'Campbell', 'Richard', NULL, 'M', NULL, NULL,'1/16/1941',NULL)
go
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(29, 'Campbell', 'Adam', NULL, 'M', 26, 8,'1/30/1981',NULL)
INSERT dbo.Person (PersonID, LastName, FirstName, MaidenName, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(30, 'Campbell', 'Amy', 'Johnson', 'F', NULL, NULL,'2/27/1959',NULL)
INSERT dbo.Person (PersonID, LastName, FirstName, MaidenName, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(32, 'Campbell', 'Elizabeth', 'Straka', 'F', NULL, NULL, '6/24/1939','1/1/1972')
go
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(27, 'Campbell', 'Alexia', NULL, 'F', 26 , 32, '8/12/1970','1/1/1972')
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(28, 'Campbell', 'Cameron', NULL, 'M', 26, 32,'3/13/1965',NULL)
go
INSERT dbo.Person (PersonID, LastName, FirstName, SrJr, Gender, FatherID, MotherID, DateOfBirth, DateOfDeath)
  VALUES(31, 'Campbell', 'William', NULL, 'M', 28, 30, '1/1/1987','6/30/1997')

go

INSERT dbo.Marriage(MarriageID, HusbandID, WifeID, DateOfWedding, DateOfDivorce)
  VALUES(1, 2, 1, '6/20/1920', NULL)
INSERT dbo.Marriage(MarriageID, HusbandID, WifeID, DateOfWedding, DateOfDivorce)
  VALUES(2, 4, 3 , '4/14/1926', NULL)
INSERT dbo.Marriage(MarriageID, HusbandID, WifeID, DateOfWedding, DateOfDivorce)
  VALUES(3, 5,  6, '12/1/1948', NULL)
INSERT dbo.Marriage(MarriageID, HusbandID, WifeID, DateOfWedding, DateOfDivorce)
  VALUES(4, 10, 12 , '1/1/1975', NULL)
INSERT dbo.Marriage(MarriageID, HusbandID, WifeID, DateOfWedding, DateOfDivorce)
  VALUES(5, 13, 8, '5/2/1968', '1/1/1974')
INSERT dbo.Marriage(MarriageID, HusbandID, WifeID, DateOfWedding, DateOfDivorce)
  VALUES(6, 14, 25, '4/14/2018', NULL)
INSERT dbo.Marriage(MarriageID, HusbandID, WifeID, DateOfWedding, DateOfDivorce)
  VALUES(7, 26, 8, '9/4/1977', NULL)
INSERT dbo.Marriage(MarriageID, HusbandID, WifeID, DateOfWedding, DateOfDivorce)
  VALUES(8, 19, 20, '8/25/2000', '1/1/2007')
INSERT dbo.Marriage(MarriageID, HusbandID, WifeID, DateOfWedding, DateOfDivorce)
  VALUES(9, 28, 30, '6/2/1984', NULL)
INSERT dbo.Marriage(MarriageID, HusbandID, WifeID, DateOfWedding, DateOfDivorce)
  VALUES(10, 26, 32, '4/14/1963', NULL)

SELECT * FROM Person

SELECT * FROM Marriage

