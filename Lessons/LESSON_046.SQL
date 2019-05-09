-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Developing Solutions
-- Lesson 46 - T-SQL and Stored Procedures
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
---------------------------------------------
-- Introducing Stored Procedures

-- Create, Alter, Drop
USE OBXKites;
go

CREATE PROCEDURE CategoryList
AS 
SELECT ProductCategoryName, ProductCategoryDescription  
  FROM dbo.ProductCategory;
RETURN; 
go

-- Executing the Sproc & Returning a Result Set
EXEC CategoryList;

-- Calling Remote Stored Procedures
EXEC [HPPRESENT\SECOND].OBXKites.dbo.pProductCategory_AddNew 'Food', 'Eat-ables'

-- Compiling Stored Procedures
CREATE PROCEDURE CategoryList
WITH RECOMPILE
AS 
SELECT ProductCategoryName, ProductCategoryDescription
  FROM dbo.ProductCategory;
RETURN;
go

EXEC sp_recompile CategoryList;