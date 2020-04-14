-----------------------------------------------------------
-- SQL Server 2020
-- 
-- Developing Solutions
-- Lesson 55- T-SQL Programming - Triggers and Audit Trail
-- 
-- Ahmed Mohamady 
-----------------------------------------------------------

-- Nested - Server wide setting
EXEC sp_configure 'Nested Triggers', 1
Reconfigure



-- Recursive Trigger - Database wide setting
USE OBXKites

ALTER DATABASE OBXKites SET RECURSIVE_TRIGGERS ON 

ALTER TABLE Product
  ADD Created DATETIME NOT NULL DEFAULT GetDate()
ALTER TABLE Product
  ADD Modified DATETIME NOT NULL DEFAULT GetDate()


-- assumes created and modified date columns have been added to the Product table. 
CREATE TRIGGER Products_ModifiedDate ON dbo.Product 
AFTER UPDATE
AS
  SET NoCount ON
  -- Check nest level
  PRINT Trigger_NestLevel()  -- for demo purposes, remove from production code
  If Trigger_NestLevel() > 1
    RETURN	
  -- block manual update of created/modified columns
  IF (UPDATE(Created) or UPDATE(Modified)) 
       AND Trigger_NestLevel() = 1
    BEGIN
      RAISERROR('Update failed.', 16, 1)
      ROLLBACK
      RETURN
    END
  -- Update the Modified date
  UPDATE Product 
    SET modified = getdate() 
    FROM Product  
      JOIN Inserted
        ON Product.ProductID = Inserted.ProductID
-- end of trigger 
go




UPDATE PRODUCT 
  SET ProductName = 'Modifed Trigger'
  WHERE Code = '1002'

SELECT Code, ProductName, Created, Modified
  FROM Product
  WHERE Code = '1002'
