-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 41 - Modifying Data
-- 
-- Ahmed Mohamady 
--------------------------------------------------------
-----------------------------------------------------------
-- Using the Output clause

USE [NEW_DB]

INSERT dbo.Guide (LastName, FirstName, Qualifications)
  OUTPUT Inserted.* 
  VALUES('Nielsen', 'Paul', 'diver');

UPDATE dbo.Guide 
  SET Qualifications = 'Scuba'
  OUTPUT Deleted.Qualifications as OldQuals, Inserted.Qualifications as NewQuals
  Where [Index] = 3;

-- with table variable
DECLARE @DeletedGuides TABLE (
  GuideID INT,
  LastName VARCHAR(50),
  FirstName VARCHAR(50)
  );

DELETE dbo.Guide
  OUTPUT Deleted.[Index], Deleted.LastName, Deleted.FirstName
  INTO @DeletedGuides
  WHERE [Index] = 2; 

SELECT * FROM @DeletedGuides;

