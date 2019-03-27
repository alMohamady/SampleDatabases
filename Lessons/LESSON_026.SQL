-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 26 - Aggregating Data
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------

-----------------------------------------------------------
-- Using the new Windowing Functions

Use AdventureWorks2017;

SELECT ProductID, TransactionDate
  FROM Production.TransactionHistory
  ORDER BY TransactionDate;

SELECT ProductID, TransactionDate, 
    Row_Number() OVER(ORDER BY TransactionDate) as RowNumDate,
    Row_Number() OVER(ORDER BY ProductID) + 5000 as RowNumiD 
  FROM Production.TransactionHistory
  -- not permitted 
  Where Row_Number() OVER(ORDER BY TransactionDate) Between 10001 AND 20000
  ORDER BY TransactionDate;

-- Select mid-range of rownumbers  & every 5th row 
SELECT RowNum, ProductID, TransactionDate
  FROM (SELECT ProductID, TransactionDate, 
          Row_Number() OVER(ORDER BY TransactionDate) as RowNum 
          FROM Production.TransactionHistory) sq
  WHERE RowNum Between 10001 AND 20000
      AND RowNum%5 = 0
  ORDER BY RowNum ;

-- Ranking and Windowing
SELECT SalesOrderId, CustomerId, TerritoryID,
  ROW_NUMBER() OVER(ORDER BY CustomerId) AS RowNum,
  RANK()       OVER(ORDER BY CustomerId) AS [Rank],
  DENSE_RANK() OVER(ORDER BY CustomerId) AS [DenseRank],
  NTILE(5)     OVER(ORDER BY CustomerId) AS NTile5,
  RANK()       OVER(PARTITION BY TerritoryID ORDER BY CustomerId) AS [Partition]
FROM  Sales.SalesOrderHeader;

-- Percentile Ranking
SELECT SalesOrderId, CustomerId,
    NTILE(100)     OVER(ORDER BY CustomerId) AS Percentile
  FROM  Sales.SalesOrderHeader
  ORDER BY CustomerId

-- Sample Data 
SELECT 
 SalesOrderId, CustomerId
  FROM  Sales.SalesOrderHeader TABLESAMPLE (10000 rows)

SELECT 
 SalesOrderId, CustomerId
  FROM  Sales.SalesOrderHeader TABLESAMPLE (10 percent)
  ORDER BY CustomerId