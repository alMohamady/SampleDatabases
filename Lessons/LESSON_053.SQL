-----------------------------------------------------------
-- SQL Server 2019
-- 
-- Developing Solutions
-- Lesson 53- T-SQL Programming - Triggers and Audit Trail
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
-----------------------------------------------------------------------
-- Using "Instead of" Triggers

USE FAMILY 

CREATE TRIGGER TriggerTwo ON Person
INSTEAD OF Insert
AS 
PRINT 'In the Instead-of Trigger' 
go

INSERT Person(PersonID, LastName, FirstName, Gender)
  VALUES (99, 'McDoogle', 'John','M')

SELECT *
  FROM Person
  WHERE PersonID = 99

DROP TRIGGER TriggerTwo

/*
Transaction Flow
1 - Identity Insert Check
2 - Nullability Constraint
3 - Data Type Check
4 - Instead of Trigger
5 - Primary Key Constraint
6 - Check Constraints
7 - Foreign Key Constraint
8 - DML execution and update to Transaction Log
9 - After Trigger 
10 - Commit Transaction
 */