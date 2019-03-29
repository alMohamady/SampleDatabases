-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 28 - Aggregating Data
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
---------------------------------------------
-- Grouping and Aggregating

SELECT Category, 
    Count(*) as Count, 
    Sum(Amount) as [Sum], 
    Avg(Amount) as [Avg], 
    Min(Amount) as [Min], 
    Max(Amount) as [Max]
  FROM RawData
  GROUP BY Category

-- Group by occurs after the where clause
SELECT Category, 
    Count(*) as Count, 
    Sum(Amount) as [Sum], 
    Avg(Amount) as [Avg], 
    Min(Amount) as [Min], 
    Max(Amount) as [Max]
  FROM RawData
  WHERE Year(SalesDate) = 2006
  GROUP BY Category

-- Grouping By multiple columns
SELECT Year(SalesDate) as [Year], DatePart(q,SalesDate) as [Quarter],
    Count(*) as Count, 
    Sum(Amount) as [Sum], 
    Avg(Amount) as [Avg], 
    Min(Amount) as [Min], 
    Max(Amount) as [Max]
  FROM RawData
  GROUP BY Year(SalesDate), DatePart(q,SalesDate)
  
---------------------------------------------
-- Including Descriptions

IF EXISTS(SELECT * FROM sysobjects WHERE Name = 'RawCategory')
  DROP TABLE RawCategory

CREATE TABLE RawCategory (
  RawCategoryID  CHAR(1),
  CategoryName   VARCHAR(25)
  )

INSERT RawCategory (RawCategoryID, CategoryName)
  VALUES ('X', 'Sci-Fi')
INSERT RawCategory (RawCategoryID, CategoryName)
  VALUES ('Y', 'Philosophy')
INSERT RawCategory (RawCategoryID, CategoryName)
  VALUES ('Z', 'Zoology')
  
  
  
 
-- including Amount outside the aggregate function or group by will cause an error
/* 
SELECT Category, CategoryName, 
    Sum(Amount) as [Sum], 
    Avg(Amount) as [Avg], 
    Min(Amount) as [Min], 
    Max(Amount) as [Max]
  FROM RawData R
    JOIN RawCategory C
      ON R.Category = C.RawCategoryID
  GROUP BY Category
*/


-- Solution 1: include all Amount in the Group By 
SELECT Category, CategoryName, 
    Sum(Amount) as [Sum], 
    Avg(Amount) as [Avg], 
    Min(Amount) as [Min], 
    Max(Amount) as [Max]
  FROM RawData R
    JOIN RawCategory C
      ON R.Category = C.RawCategoryID
  GROUP BY Category, CategoryName
  ORDER BY Category, CategoryName

-- Solution 2: Aggregate in Subquery, description in outer query
SELECT sq.Category, CategoryName, sq.[Sum], sq.[Avg], sq.[Min], sq.[Max]
  FROM (SELECT Category,
            Sum(Amount) as [Sum], 
            Avg(Amount) as [Avg], 
            Min(Amount) as [Min], 
            Max(Amount) as [Max]
          FROM RawData
          GROUP BY Category ) sq
    JOIN RawCategory C
      ON sq.Category = C.RawCategoryID
  ORDER BY Category, CategoryName