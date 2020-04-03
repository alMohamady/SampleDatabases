-----------------------------------------------------------
-- SQL Server 2019
-- 
-- Developing Solutions
-- Lesson 54- T-SQL Programming - Triggers and Audit Trail
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
--------------------------------------------------------
-- Disabling Triggers

ALTER TABLE Person 
  DISABLE TRIGGER TriggerOne

SELECT OBJECTPROPERTY(OBJECT_ID('TriggerOne'),'ExecIsTriggerDisabled')


ALTER TABLE Person 
  ENABLE TRIGGER TriggerOne

SELECT OBJECTPROPERTY(OBJECT_ID('TriggerOne'),'ExecIsTriggerDisabled')


-- Viewing Trigger Status
SELECT SubString(S2.Name,1,30) as [Table],
  SubString(S.Name, 1,30) as [Trigger],
  CASE (SELECT -- Correlated subquery
         OBJECTPROPERTY(OBJECT_ID(S.Name),
           'ExecIsTriggerDisabled'))
    WHEN 0 THEN 'Enabled'
    WHEN 1 THEN 'Disabled'
  END AS Status
  FROM Sysobjects S
    JOIN Sysobjects S2
      ON S.parent_obj = S2.ID
  WHERE S.Type = 'TR'
  ORDER BY [Table], [Trigger]


-------------------------------------------------------
-- Using the Update() function

ALTER TRIGGER TriggerOne ON Person
AFTER Insert, Update
AS 
IF Update(LastName)
  PRINT 'You modified the LastName column'
ELSE 
  PRINT 'The LastName column is untouched.'


UPDATE Person
  SET LastName = 'Johnson'
  WHERE PersonID = 25

UPDATE Person
  SET FirstName = 'Joe'
  WHERE PersonID = 25


-----------------------------------------------
-- Selecting Transaction Data

USE Family

ALTER TRIGGER TriggerOne ON Person
AFTER Insert, Update
AS 
SET NoCount ON
IF Update(LastName)
  SELECT 'You modified the LastName column to ' + Inserted.LastName
    FROM Inserted


UPDATE Person
  SET LastName = 'Johnson'
  WHERE PersonID = 32

ALTER TRIGGER TriggerOne ON Person
AFTER Insert, Update
AS
SELECT CAST(D.PersonID as VARCHAR(4)) + ': ' + D.LastName + ' changed to ' + I.LastName
  FROM Inserted I
    JOIN Deleted D
      ON I.PersonID = D.PersonID

UPDATE Person
  SET LastName = 'Carter'
  WHERE LastName = 'Johnson'
