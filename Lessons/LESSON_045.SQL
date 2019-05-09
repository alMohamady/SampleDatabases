-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Developing Solutions
-- Lesson 45 - T-SQL and Stored Procedures
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
----------------------------------------------------------------
-- Developing Dynamic SQL 

-- Simple EXEC
USE Family;
EXEC ('Select LastName from Person Where PersonID = 12');

-- sp_executeSQL
EXEC sp_executeSQL 
  N'Select LastName from Person Where PersonID = @PersonSelect',
  N'@PersonSelect INT', 
  @PersonSelect = 12;


-- Developing Dynamic SQL Code 
USE OBXKites;

DECLARE 
  @SQL NVARCHAR(1024),
  @SQLWhere NVARCHAR(1024),
  @NeedsAnd BIT, 

-- User Parameters
  @ProductName VARCHAR(50),
  @ProductCode VARCHAR(10),
  @ProductCategory VARCHAR(50);

-- Initilize Variables
SET @NeedsAnd = 0; 
SET @SQLWhere = '';

-- Simulate User's Requirements
SET @ProductName = NULL;
SET @ProductCode = 1001;
SET @ProductCategory = NULL;

-- Assembling Dynamic SQL 

-- Set up initial SQL Select
IF @ProductCategory IS NULL 
  SET @SQL = 'Select ProductName from Product';
ELSE
  SET @SQL = 'Select ProductName from Product 
                        Join ProductCategory 
                        on Product.ProductCategoryID 
                        = ProductCategory.ProductCategoryID';

-- Build the Dynamic Where Clause
IF @ProductName IS NOT NULL 
  BEGIN;
    SET @SQLWhere = 'ProductName = ' + @ProductName;
    SET @NeedsAnd = 1;
  END;

 IF @ProductCode IS NOT NULL 
  BEGIN;
    IF @NeedsAnd = 1 
      SET @SQLWhere = @SQLWhere + ' and '; 
    SET @SQLWhere = 'Code = ' + @ProductCode;
    SET @NeedsAnd = 1;
  END;

 IF @ProductCategory IS NOT NULL
  BEGIN;
    IF @NeedsAnd = 1 
      SET @SQLWhere = @SQLWhere + ' and '; 
    SET @SQLWhere = 'ProductCategory = ' + @ProductCategory ;
    SET @NeedsAnd = 1;
  END;

-- Assemble the select and the where portions of the dynamic SQL 
IF @NeedsAnd = 1
  SET @SQL = @SQL + ' where ' + @SQLWhere;

Print @SQL;

EXEC sp_executeSQL @SQL 
  WITH RECOMPILE;