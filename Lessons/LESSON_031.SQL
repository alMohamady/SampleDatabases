-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 31 - Aggregating Data
-- 
-- Ahmed Mohamady 
--------------------------------------------------------
-------------------------------------------------------------------
-- Generating Crosstab(Pivot) Tables

-- Fixed Column CrossTab with Category Subtotal- CASE Method
SELECT Category,
  SUM(Case Region WHEN 'South' THEN Amount ELSE 0 END) AS South,
  SUM(Case Region WHEN 'NorthEast' THEN Amount ELSE 0 END) AS NorthEast,
  SUM(Case Region WHEN 'MidWest' THEN Amount ELSE 0 END) AS MidWest,
  SUM(Case Region WHEN 'West' THEN Amount ELSE 0 END) AS West,
  SUM(Amount) as Total 
  FROM RawData
  GROUP BY Category
  ORDER BY Category


-- Fixed Column Crosstab - PIVOT Method
SELECT Category, SalesDate, South, NorthEast, MidWest, West
  FROM RawData
    PIVOT 
      (Sum (Amount)
      FOR Region IN (South, NorthEast, MidWest, West)
      ) AS pt

SELECT Category, South, NorthEast, MidWest, West
  FROM (Select Category, Region, Amount from RawData) sq
    PIVOT 
      (Sum (Amount)
      FOR Region IN (South, NorthEast, MidWest, West)
      ) AS pt


-- Fixed Column Crosstab with Category Subtotal - PIVOT Method
SELECT Category, South, NorthEast, MidWest, West, 
  IsNull(South,0) + IsNull(NorthEast,0) + IsNull(MidWest,0) + IsNull(West,0) as Total
  FROM (Select Category, Region, Amount from RawData) sq
    PIVOT 
      (Sum (Amount)
      FOR Region IN (South, NorthEast, MidWest, West)
      ) AS pt

-- Fixed Column Crosstab with Filter - PIVOT Method
-- Must filter within the FROM clause (using subquery) prior to Pivot operation
SELECT Category, South, NorthEast, MidWest, West, 
  IsNull(South,0) + IsNull(NorthEast,0) + IsNull(MidWest,0) + IsNull(West,0) as Total
  FROM (Select Region, Category, Amount
          From RawData 
          Where Category = 'Z') sq
    PIVOT 
      (Sum (Amount)
      FOR Region IN (South, NorthEast, MidWest, West)
      ) AS pt

-- Dynamic CrossTabs with Multiple Assignment Variable and Pivot Method 
-- Appending to a variable within a query to dynamically generate the column names 

DECLARE @SQLStr NVARCHAR(1024)
SET @SQLStr = ''
SELECT @SQLStr = @SQLStr  + [a].[Column] + ', '
  FROM 
    (SELECT DISTINCT Region as [Column]
      FROM RawData  ) as a

SET @SQLStr = Left(@SQLStr, Len(@SQLStr) - 1)

SET @SQLStr = 'SELECT Category, ' 
    + @SQLStr 
    + ' FROM (Select Category, Region, Amount from RawData) sq PIVOT (Sum (Amount) FOR Region IN ('
    + @SQLStr
    + ')) AS pt'
PRINT @SQLStr

EXEC sp_executesql @SQLStr

---------------------------------------------------------------