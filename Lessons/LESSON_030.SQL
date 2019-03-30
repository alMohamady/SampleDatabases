-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 30 - Aggregating Data
-- 
-- Ahmed Mohamady 
--------------------------------------------------------

--------------------------------------------------------
-- Adding Grand Totals

-- Sum of single column Group By (Roll-Up)
SELECT Grouping(Category), Category,        
    CASE Grouping(Category) 
      WHEN 0 THEN Category
      WHEN 1 THEN 'All Categories' 
    END AS Category, 
    Count(*) as Count
  FROM RawData
  GROUP BY Category
    WITH ROLLUP

-- Sum of Mulitple column Group By (Roll-Up)
-- Second Group by Column w/ subtotals

SELECT     
    CASE Grouping(Category) 
      WHEN 0 THEN Category
      WHEN 1 THEN 'All Categories' 
    END AS Category,
    CASE Grouping(Year(SalesDate)) 
      WHEN 0 THEN Cast(Year(SalesDate) as CHAR(8))
      WHEN 1 THEN 'All Years' 
    END AS Year,
    Count(*) as Count
  FROM RawData
  GROUP BY Category, Year(SalesDate)
    WITH ROLLUP

-- Multidimensional column Group By (Cube)
SELECT     
    CASE Grouping(Category) 
      WHEN 0 THEN Category
      WHEN 1 THEN 'All Categories' 
    END AS Category,
    CASE Grouping(Year(SalesDate)) 
      WHEN 0 THEN Cast(Year(SalesDate) as CHAR(8))
      WHEN 1 THEN 'All Years' 
    END AS Year,    Count(*) as Count
  FROM RawData
  GROUP BY Category, Year(SalesDate)
    WITH CUBE
