-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 29 - Aggregating Data
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
-----------------------------------------------------------
-- Including all Group By Values

-- Left Outer Join Group Bys
SELECT Year(SalesDate) AS [Year],
    Count(*) as Count, 
    Sum(Amount) as [Sum], 
    Avg(Amount) as [Avg], 
    Min(Amount) as [Min], 
    Max(Amount) as [Max]
  FROM RawData
  WHERE Year(SalesDate) = 2006  -- (There are a few 2005 rows in the RawData table)
  GROUP BY ALL Year(SalesDate)



------------------------------------------------------------------
-- Nesting Aggregations

-- Which Category sold the most in each quarter?

-- Can't nest aggregate function - error: 
/*
    Select Y,Q, Max(Sum) as MaxSum 
        FROM ( -- Calculate Sums
              SELECT Category, Year(SalesDate) as Y, DatePart(q,SalesDate) as Q, max(Sum(Amount)) as Sum
                FROM RawData
                GROUP BY Category, Year(SalesDate), DatePart(q,SalesDate)
              ) sq
        GROUP BY Y,Q
        ORDER BY Y,Q
*/

-- Solution: Including Detail description 

   SELECT MaxQuery.Y, MaxQuery.Q, AllQuery.Category, MaxQuery.MaxSum as sales
      FROM (-- Find Max Sum Per Year/Quarter
            Select Y,Q, Max(Sum) as MaxSum 
              FROM ( -- Calculate Sums
                    SELECT Category, Year(SalesDate) as Y, DatePart(q,SalesDate) as Q, Sum(Amount) as Sum
                      FROM RawData
                      GROUP BY Category, Year(SalesDate), DatePart(q,SalesDate)
                    ) sq
              GROUP BY Y,Q
            ) MaxQuery
        JOIN (-- All Amount Query
              SELECT Category, Year(SalesDate) as Y, DatePart(q,SalesDate) as Q, Sum(Amount) as Sum
              FROM RawData
                GROUP BY Category, Year(SalesDate), DatePart(q,SalesDate)
              )AllQuery
          ON MaxQuery.Y = AllQuery.Y
            AND MaxQuery.Q = AllQuery.Q
            AND MaxQuery.MaxSum = AllQuery.Sum
        ORDER BY MaxQuery.Y, MaxQuery.Q

		
		
---------------------------------------------		