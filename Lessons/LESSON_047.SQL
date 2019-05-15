-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Developing Solutions
-- Lesson 47 - T-SQL and Stored Procedures
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------
----------------------------------------------------
-- Passing Parameters

-- Input Parameters
USE OBXKites;

go
CREATE PROCEDURE CategoryGet
  (@CategoryName NVARCHAR(35))
AS
SELECT ProductCategoryName, ProductCategoryDescription 
  FROM dbo.ProductCategory
  WHERE ProductCategoryName = @CategoryName;
go

EXEC CategoryGet @CategoryName='Kite';


-- Parameter Defaults
CREATE PROCEDURE pProductCategory_Fetch2(
  @Search NVARCHAR(50) = NULL
   )
-- If @Search = null then return all ProductCategories
-- If @Search is value then try to find by Name
AS 
  SET NOCOUNT ON;
  SELECT ProductCategoryName, ProductCategoryDescription
    FROM dbo.ProductCategory
    WHERE ProductCategoryName = @Search
      OR @Search IS NULL;
  IF @@RowCount = 0  
    RAISERROR('Product Category ''%s'' Not Found.',14,1,@Search);
go

EXEC pProductCategory_Fetch2 'OBX';

EXEC pProductCategory_Fetch2;