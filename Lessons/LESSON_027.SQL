-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 27 - Aggregating Data
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------

-----------------------------------------------------------
-- Using Aggregate Functions
go

-- Build the sample data 
USE NEW_DB

IF EXISTS(SELECT * FROM sysobjects WHERE Name = 'RawData')
  DROP TABLE RawData
go

CREATE TABLE RawData (
  Region VARCHAR(10),
  Category CHAR(1),
  Amount INT,
  SalesDate DateTime
  )

go

INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'South', 'Y',     12, '11/1/2005')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'South', 'Y',     24, '11/1/2005')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'South', 'Y',     15, '12/1/2005')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'NorthEast', 'Y', 28, '12/1/2005')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'South', 'X',     11, '1/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'MidWest', 'X',   24, '1/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'West', 'X',      36, '2/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'South', 'Y',     47, '2/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'MidWest', 'Y',   38, '3/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'NorthEast', 'Y', 62, '3/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'South', 'Z',     33, '4/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'MidWest', 'Z',   83, '4/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'West', 'Z',      44, '5/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'NorthEast', 'Z', 55, '5/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'South', 'X',     68, '6/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'South', 'X',     86, '6/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'South', 'Y',     54, '7/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'South', 'Y',     63, '7/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'South', 'Y',     72, '8/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'NorthEast', 'Y', 91, '8/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'NorthEast', 'Y', null, '8/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'NorthEast', 'Y', null, '8/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'NorthEast', 'Y', null, '8/1/2006')
INSERT RawData (Region, Category, Amount, SalesDate)
  VALUES( 'NorthEast', 'Y', null, '8/1/2006')

-- check the Amount
SELECT * FROM RawData 

-- Simple Aggregations
SELECT
    Count(*) as Count, 
    Sum(Amount) as [Sum], 
    Avg(Amount) as [Avg], 
    Min(Amount) as [Min], 
    Max(Amount) as [Max]
  FROM RawData

-- How Nulls affect Averages
SELECT Avg(Cast((Amount)as Numeric(9,5))) as [Numeric Avg],
  Avg(Amount) as [Int Avg],
  Sum(Amount) / Count(*) as [Manual Avg]
  FROM RawData




-- Statistical Functions
-- standard deviation
-- variance 

SELECT 
    Count(*) as Count, 
    StDevP(Amount) as [StDevP],
    VarP(Amount) as [VarP]
  FROM RawData

SELECT 
    Count(*) as Count, 
    StDev(Amount) as [StDev],
    Var(Amount) as [Var]
  FROM RawData
  WHERE Year(SalesDate) = 2006