-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 33 - Using Full-Text Search
-- 
-- Ahmed Mohamady 
--------------------------------------------------------
-----------------------------------------------------
-- Searching for Words

USE AESOP

-- Contains
SELECT Title
  FROM Fable 
  WHERE CONTAINS (Fable.*,'Lion')

-- Joining with Full-Text Search
SELECT * 
  FROM CONTAINSTABLE (Fable, *, 'Lion')

SELECT Fable.Title, Rank 
  FROM Fable  
    JOIN CONTAINSTABLE (Fable, *, 'Lion') FTS
    ON Fable.FableID = FTS.[KEY]
  ORDER BY FTS.Rank DESC

SELECT Fable.Title, Rank 
  FROM Fable  
    JOIN CONTAINSTABLE (Fable, *, 'Lion', 2) FTS
    ON Fable.FableID = FTS.[KEY]
  ORDER BY FTS.Rank

-- Advanced Options

-- Phrases 
SELECT Title
  FROM Fable 
  WHERE CONTAINS (*,' "Wolf! Wolf!" ')

-- Or, And
SELECT Title
  FROM Fable 
  WHERE CONTAINS (FableText,'Tortoise AND Hare')

SELECT Title
  FROM Fable 
  WHERE CONTAINS (*,' "Thrifty AND supperless" ')

SELECT Title
  FROM Fable 
  WHERE CONTAINS (*,'Thrifty')
    AND CONTAINS(*,'supperless')

-- Wildcards * 
SELECT Title
  FROM Fable 
  WHERE CONTAINS (*,' "Hunt*" ')

-- Near
SELECT Title
  FROM Fable 
  WHERE CONTAINS (*,'pardoned NEAR forest')

SELECT Title
  FROM Fable 
  WHERE CONTAINS (*,'lion NEAR paw NEAR bleeding')

SELECT Fable.Title, Rank 
  FROM Fable  
    JOIN CONTAINSTABLE (Fable, *,'life NEAR death') FTS
     ON Fable.FableID = FTS.[KEY]
  ORDER BY FTS.Rank DESC

-- Weighting
SELECT Fable.Title, FTS.Rank
  FROM Fable  
    JOIN CONTAINSTABLE (Fable, fabletext, 'ISABOUT (Lion weight (.5), Brave weight (.5), Eagle weight (.5))',20) FTS
    ON Fable.FableID = FTS.[KEY]
    ORDER BY Rank DESC

SELECT Fable.Title, FTS.Rank
  FROM Fable  
    JOIN CONTAINSTABLE (Fable, fabletext, 'ISABOUT (Lion weight (.2), Brave weight (.2), Eagle weight (.8))',20) FTS
    ON Fable.FableID = FTS.[KEY]
    ORDER BY Rank DESC

SELECT Fable.Title, FTS.Rank
  FROM Fable  
    JOIN CONTAINSTABLE (Fable, *, 'ISABOUT (Lion weight (.2), Brave weight (.2), Eagle weight (.8))',20) FTS
    ON Fable.FableID = FTS.[KEY]
    ORDER BY Rank DESC

-- Inflection
SELECT Title
  FROM Fable 
  WHERE CONTAINS (*,'FORMSOF(INFLECTIONAL,pity)')

SELECT Title
  FROM Fable 
  WHERE CONTAINS (*,'FORMSOF(INFLECTIONAL,geese)')

SELECT Title
  FROM Fable 
  WHERE CONTAINS (*,'FORMSOF(INFLECTIONAL,carry)')

SELECT Title
  FROM Fable 
  WHERE CONTAINS (*,'FORMSOF(INFLECTIONAL,fly)')
