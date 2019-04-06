-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 32 - Using Full-Text Search
-- 
-- Ahmed Mohamady 
--------------------------------------------------------
-----------------------------------------------------------
-- Creating a Full-Text Index

USE AESOP

-- SQL Where Like
SELECT Title
  FROM Fable
  WHERE Fabletext LIKE '%lion%'
    AND Fabletext LIKE '%bold%'

CREATE FULLTEXT CATALOG AesopFT

CREATE FULLTEXT INDEX ON dbo.Fable(Title, Moral, Fabletext) 
	KEY INDEX FablePK ON AesopFT 
	WITH CHANGE_TRACKING AUTO
GO


-----------------------------------------------------
-- Searching for Words

-- Contains
SELECT Title
  FROM Fable 
  WHERE CONTAINS (Fable.*,'Lion')

