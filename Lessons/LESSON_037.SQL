-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 37 - Modifying Data
-- 
-- Ahmed Mohamady 
--------------------------------------------------------
-----------------------------------------------------------
-- Inserting Data

USE NEW_DB; 


CREATE TABLE [dbo].[Guide](
	[Index] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Qualifications] [varchar](50) NULL
) ON [PRIMARY]

-- INSERT/VALUES
INSERT INTO dbo.Guide (LastName, FirstName, Qualifications)
  VALUES ('Smith', 'Dan', 'Diver, Whitewater Rafting');

INSERT INTO dbo.Guide (FirstName, LastName, Qualifications)
  VALUES ('Jeff', 'Davis', 'Marine Biologist, Diver');

INSERT INTO dbo.Guide (FirstName, LastName)
  VALUES ('Tammie', 'Commer');

SELECT * from dbo.Guide;

-- INSERT/VALUES without a insert column listing
INSERT dbo.Guide 
  VALUES ('Jones', 'Lauren', 'First Aid, Rescue/Extraction');

SELECT GuideID, LastName, FirstName, Qualifications 
  FROM dbo.Guide;


-- INSERT/VALUES w/ expression
INSERT dbo.Guide (FirstName, LastName, Qualifications)
  VALUES ('Greg', 'Wilson' , 'Rock Climbing' + ', ' + 'First Aid');

SELECT * from dbo.Guide;


-- INSERT/SELECT

USE OBXKites;
-- Using a fresh copy of OBXKites without population

--(Corrected from the text - added ContactCode)
INSERT dbo.Contact (FirstName, ContactCode, LastName, CompanyName)
  SELECT FirstName, LastName, GuideID, 'Cape Hatteras Adv.' 
    FROM NEW_DB.dbo.Guide;

SELECT ContactID, FirstName AS FIRST, LastName AS LAST , CompanyName 
  FROM dbo.Contact;
