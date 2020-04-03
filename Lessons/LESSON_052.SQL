-----------------------------------------------------------
-- SQL Server 2019
-- 
-- Developing Solutions
-- Lesson 52- T-SQL Programming - Triggers and Audit Trail
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
-----------------------------------------------------------
-- Introducing After Triggers 

USE FAMILY 
go
CREATE TRIGGER TriggerOne ON Person
AFTER Insert  -- old syntax FOR
AS 
PRINT 'In the After Trigger' 
go

INSERT Person(PersonID, LastName, FirstName, Gender)
  VALUES (50, 'Flanigan', 'Brandie','F')