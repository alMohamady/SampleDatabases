-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 34 - Using Full-Text Search
-- 
-- Ahmed Mohamady 
--------------------------------------------------------
----------------------------------------------------
-- Using Fuzzy Searches

-- FreeText

SELECT Title
  FROM Fable 
  WHERE FREETEXT (*,'The Tortoise beat the Hare in the big race')

SELECT Title
  FROM Fable 
  WHERE FREETEXT (*,'The eagle was shot by an arrow')

SELECT Title
  FROM Fable 
  WHERE FREETEXT (*,'The brave hunter kills the lion')

-- FreeText Table

SELECT Fable.Title, FTS.Rank
  FROM Fable  
    JOIN FREETEXTTABLE (Fable, *, 'The brave hunter kills the lion',20) FTS
      ON Fable.FableID = FTS.[KEY]
  ORDER BY Rank DESC

SELECT Fable.Title, FTS.Rank
  FROM Fable  
    JOIN FREETEXTTABLE (Fable, *, 'The eagle was shot by an arrow',20) FTS
      ON Fable.FableID = FTS.[KEY]
  ORDER BY Rank DESC