-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 38 - Modifying Data
-- 
-- Ahmed Mohamady 
--------------------------------------------------------
-----------------------------------------------------------
-- Inserting Data 02

-- INSERT/Exec

Use NEW_DB
Go
-- create the sample stored procedure
CREATE PROC ListGuides
AS
SET NOCOUNT ON

-- result set 1
SELECT  FirstName, LastName
  FROM dbo.Guide;

-- result set 2
SELECT  FirstName, LastName 
  FROM  dbo.Contact
RETURN;  -- end of sproc
go

-- test the sample stored procedure
Exec ListGuides;

go
-- create a table for the insert
CREATE TABLE  dbo.GuideSample
  (FirstName VARCHAR(20),
    LastName VARCHAR(20) );

-- the insert / exec statement
INSERT GuideSample ( FirstName, LastName)
  EXEC ListGuides;

-- check to see that the insert worked
SELECT * FROM GuideSample; 

-- SELECT INTO
USE NEW_DB;

-- sample code for setting the bulk-logged behavior
Alter DATABASE NEW_DB SET RECOVERY FULL
EXEC SP_DBOPTION 'NEW_DB', 'select into/bulkcopy', 'TRUE';
go

-- the select/into statement
SELECT * INTO dbo.GuideList
  FROM dbo.Guide
  ORDER BY Lastname, FirstName;

Go
-- viewing the data structure of the new table
sp_help GuideList;

--testing the identity column of the new table
INSERT dbo.Guidelist (LastName, FirstName, Qualifications)
  VALUES('Nielsen', 'Paul','trainer');

SELECT GuideID, LastName, FirstName
  FROM dbo.GuideList;

-- INSERTing Identity Column Primary Keys
USE NEW_DB;

INSERT dbo.Guide (GuideID, FirstName, LastName)
  VALUES (10, 'Bill', 'Wilson');

SET IDENTITY_INSERT Guide On; 

INSERT dbo.Guide (GuideID, FirstName, LastName)
  VALUES (10, 'Bill', 'Wilson');

INSERT dbo.Guide (GuideID, FirstName, LastName)
  VALUES (7, 'Sue', 'Atlas');

SET IDENTITY_INSERT Guide Off; 

INSERT dbo.Guide ( FirstName, LastName)
  VALUES ( 'Arnold', 'Bistier');

SELECT GuideID, FirstName, LastName from dbo.Guide;