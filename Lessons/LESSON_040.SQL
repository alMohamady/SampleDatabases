-----------------------------------------------------------
-- SQL Server 2017
-- 
-- Selecting Data
-- Lesson 40 - Modifying Data
-- 
-- Ahmed Mohamady 
--------------------------------------------------------
-----------------------------------------------------------
-- Deleting Data

USE OBXKites;

DELETE  FROM OBXKites.dbo.Product;
   -- w/o WHERE clause deletes all rows 

DELETE FROM dbo.Product 
  WHERE ProductID = 'DB8D8D60-76F4-46C3-90E6-A8648F63C0F0';

-- delete all the product in the books category
DELETE Product
  FROM dbo.Product
  JOIN ProductCategory
    ON Product.ProductCategoryID 
      = ProductCategory.ProductCategoryID
  WHERE ProductcategoryName = 'Video';

-- Building a foreign key with referential integrity that cascades deletes
USE [NEW_DB];

CREATE TABLE dbo.Event_mm_Guide (
  EventGuideID INT IDENTITY NOT NULL PRIMARY KEY NONCLUSTERED,
  GuideID INT NOT NULL 
    FOREIGN KEY REFERENCES dbo.Guide ON DELETE CASCADE,
  LastName VARCHAR(50) NOT NULL,
  ) 
  ON [Primary];
go


--ANSI Standard alternative to Delete From
Use [NORTHWND]

DELETE FROM Orders  WHERE NOT EXISTS (SELECT * 
                  FROM [dbo].[Order Details] b 
                  WHERE 
                      Orders.[OrderID] = b.[OrderID]
					  AND 
					  Orders.[OrderID]   = 10248
                ); 


-- Truncate Table
TRUNCATE TABLE dbo.InventoryTransaction;
