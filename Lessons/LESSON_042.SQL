-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Developing Solutions
-- Lesson 42 - T-SQL and Stored Procedures
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
-----------------------------------------------------------
-- Introducing T-SQL

-- the is an ANSI style comment
USE Family;

Select FirstName, LastName      -- selects the columns
  FROM Person                        -- the source table
  Where LastName Like 'Hal%';  -- the row restriction

-- C style comments
/* 
Order table Insert Trigger
Paul Nielsen
ver 1.0 July 21, 2006
Logic: etc. 
ver 1.1: July 31, 2006, added xyz
*/

-- Debug Commands
Select 3;
Print 6;

Print 'Begining'; 
waitfor delay '00:00:02';
Print 'Done'; 

-------------------------------------------------
-- Working with Variables

-- Variable Default and Scope
DECLARE  @Test INT,
         @TestTwo NVARCHAR(25);
SELECT @Test, @TestTwo ;

SET @Test = 1;
SET @TestTwo = 'a value';
SELECT @Test, @TestTwo; 
go --terminates the variables

SELECT @Test as BatchTwo, @TestTwo;  

-- Using the Set and Select Commands
USE Family

-- multiple rows & multiple columns
Declare @TempID INT,
           @TempLastName VARCHAR(25);
SET @TempID = 99
SELECT @TempID = PersonID,
    @TempLastName = LastName
  FROM Person 
  ORDER BY PersonID
SELECT @TempID, @TempLastName;
  
-- No rows returned
Declare @TempID INT,
           @TempLastName VARCHAR(25);
SET @TempID = 99;
SELECT @TempID = PersonID,
    @TempLastName = LastName
  FROM Person 
  WHERE PersonID = 100
  ORDER BY PersonID;
SELECT @TempID, @TempLastName;

-- Using Variables Within SQL Queries
USE OBXKites;

DECLARE @ProductCode CHAR(10);
SET @ProductCode = '1001';

SELECT ProductName 
  FROM Product
  WHERE Code = @ProductCode;
